--  8.30 -->  8:30 (przed południem)
-- 20.30 --> 20:30 (popołudniu)

print("==============================================================")
print("== POCZATEK ==================================================")
print("==============================================================")

wifi.start()
wifi.mode(wifi.STATION)
station_cfg={}
--Nazwa sieci i hasło
station_cfg.ssid="AIL"
station_cfg.pwd="aHWJL5HTBI"
wifi.sta.config(station_cfg, true)

time.initntp()
time.settimezone("UTC-2")
print(time.getlocal().year)
print(time.getlocal().mon)
print(time.getlocal().day)
print(time.getlocal().hour)
print(time.getlocal().min)
localTime = time.getlocal()
print(string.format("%04d-%02d-%02d %02d:%02d:%02d DST:%d", localTime["year"], localTime["mon"], localTime["day"], localTime["hour"], localTime["min"], localTime["sec"], localTime["dst"]))

print("==============================================================")
print("== LED =======================================================")
print("==============================================================")

led = {}
  led[0] = {name = "blue on  board           ", gpio =  2, time_on_hh = 8, time_on_mm =  0, time_off_hh = 22, time_off_mm =  0, time_to_change_hh =  1, time_to_change_mm =  0,
            c_led = ledc.newChannel({gpio= 2,bis=ledc.TIMER_13_BIT,mode=ledc.HIGH_SPEED,timer=ledc.TIMER_1,channel=ledc.CHANNEL_1,frequency=1000,duty=0})}
  led[1] = {name = "green                    ", gpio = 14, time_on_hh = 8, time_on_mm =  0, time_off_hh = 22, time_off_mm =  0, time_to_change_hh =  1, time_to_change_mm =  0,
            c_led = ledc.newChannel({gpio=22,bis=ledc.TIMER_13_BIT,mode=ledc.HIGH_SPEED,timer=ledc.TIMER_1,channel=ledc.CHANNEL_1,frequency=1000,duty=0})}
  led[2] = {name = "full chlorophyll spectrum", gpio = 27, time_on_hh = 8, time_on_mm =  0, time_off_hh = 22, time_off_mm =  0, time_to_change_hh =  1, time_to_change_mm =  0,
            c_led = ledc.newChannel({gpio= 5,bis=ledc.TIMER_13_BIT,mode=ledc.HIGH_SPEED,timer=ledc.TIMER_1,channel=ledc.CHANNEL_1,frequency=1000,duty=0})}
  led[3] = {name = "cool 6500K  1.           ", gpio = 26, time_on_hh = 8, time_on_mm = 30, time_off_hh = 21, time_off_mm = 30, time_to_change_hh =  1, time_to_change_mm = 30,
            c_led = ledc.newChannel({gpio=17,bis=ledc.TIMER_13_BIT,mode=ledc.HIGH_SPEED,timer=ledc.TIMER_1,channel=ledc.CHANNEL_1,frequency=1000,duty=0})}
  led[4] = {name = "cool 6500K  2.           ", gpio = 25, time_on_hh = 8, time_on_mm =  0, time_off_hh = 22, time_off_mm =  0, time_to_change_hh =  1, time_to_change_mm = 30,
            c_led = ledc.newChannel({gpio=16,bis=ledc.TIMER_13_BIT,mode=ledc.HIGH_SPEED,timer=ledc.TIMER_1,channel=ledc.CHANNEL_1,frequency=1000,duty=0})}

-- ciepłe światło (np 2000K, 2500K lub 2700K)
-- diody ful spektrum w rozumieniu spektrum światła dla chloroflilu - światło różowo fioletowe
-- diody zimne czyli główne oświetlenie (6500K, 8500K, 10000K a nawet 12000K)
-- dodatkowe diody w celu poprawienia spektrum widzialnego światła
-- np lazurowe, zielone albo/lub pomarańczowe.
-- Białe ledy mają największy "dołek" w tym zakresie spektrum
-- celujemy w okres po południu do wieczora
-- łagodne zapalenie np przez 1h
-- łagodne zgaszenie np. przez 1h


function stop_all_pwm()
  for i, v in ipairs(led) do
    led[i].c_led:stop(ledc.IDLE_LOW)
  end
end

function x4(tx, dt, up)
  -- 0 <= tx <= dt
  if up then
    x = tx/dt
    return x*x*(x-2)*(x-2)
  else
    x = 1 + tx/dt
    return x*x*(x-2)*(x-2)
  end
end

mytimer = tmr.create()
mytimer:register(5000, tmr.ALARM_AUTO, function()
  YYYY = time.getlocal().year
  MM = time.getlocal().mon
  DD = time.getlocal().day
  time_ss = time.get()

  for i, v in ipairs(led) do

    time_to_change_ss = led[i].time_to_change_hh*3600+led[i].time_to_change_mm*60

    time_on_start = time.cal2epoch({year = YYYY, mon = MM, day = DD, hour = led[i].time_on_hh, min = led[i].time_on_mm, sec = 0})
    time_on_end = time_on_start + time_to_change_ss

    time_off_end = time.cal2epoch({year = YYYY, mon = MM, day = DD, hour = led[i].time_off_hh, min = led[i].time_off_mm, sec = 0})
    time_off_start = time_off_end - time_to_change_ss
    --rozjasniamy
    -- rozjasnianie i gaszenie w funkcji liniowej bo sinusa nie ma w tej implementacji lua...
    -- ledc.TIMER_13_BIT = 2^13 - 1 = 8191
    if time_ss < time_on_start then
      -- kanal led całkiem wyłączony
      led[i].c_led:setduty(0)
    elseif time_on_start <= time_ss and time_ss < time_on_end then
      -- kanal led w trakcie rozjasniania
      tx = time.get() - time_on_start
      led[i].c_led:setduty(x4(tx, time_to_change_ss, true)*8191)
    elseif time_on_end <= time_ss and time_ss < time_off_start then
      -- kanal led całkiem włączony
      led[i].c_led:setduty(8191)
    elseif time_off_start <= time_ss and time_ss < time_off_end then
    -- kanal led w trakcie przyciemniania
      tx = time.get() - time_off_start
      led[i].c_led:setduty(x4(tx, time_to_change_ss, false)*8191)
    elseif time_off_end <= time_ss then
    -- kanal led całkiem wyłączony
      led[i].c_led:setduty(0)
    end
  end
end)

mytimer:start()
