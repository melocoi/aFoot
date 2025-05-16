--a foot switch interface

sc = include('lib/sftct')
ft = include('lib/footie')
--scrn = include('lib/scrn')
--------------------------
--------------------------
-- screen controls  ------
--------------------------
width = 128
height = 64

posX = 40
posY = 1
i = 0.5
freq = 0.0025
amp = 2.75
offSet = 10
mult = 54.89
brite = 16

lStart = {1,51,101,151,201,251}

lEnd = {14,22,27,30,33,35} --as duration
scPre = {1,1,1,1,1,1}
scRte = {1,1,1,1,1,1}
scPan = {0.3,0.6,-0.6,0.9,-0.9,-0.3}
encPre = {"pre_1","pre_2","pre_3","pre_4","pre_5","pre_6"}

loopTimer = {loop1,loop2,loop3,loop4,loop5,loop6}

fall = {1,1,1,1,1,1}
fall1 = 1
fall2 = 1
fall3 = 1
fall4 = 1
fall5 = 1
fall6 = 1

curRec = 0
recording = false
fTime = 26

flipper = metro.init()
flipper.time = math.random(1,26)
flipper.event = function()
  flip()
end

flopper = metro.init()
flopper.time = math.random(1,26)
flopper.event = function()
  flop()
end

--------------------------
--------------------------

function init()

  sc.init()
  ft.init()
  audio.monitor_mono()
  
  for i=1,6 do
    loopTimer[i] = metro.init()
    loopTimer[i].time = lEnd[1]/(lEnd[1]+6)
    loopTimer[i].event = function()
      fall[i] = ((fall[i]+scRte[i] ) % (lEnd[i]+6))
      --redraw()
    end
    loopTimer[i]:start()
  end
 
  flipper:start()
  flopper:start()
 -- redraw()
  
end


function flip(v)
  
  local voice = math.random(1,6)
  local tV = 0
  local rate = {-1,1}
  local dir = math.random(2)
  
  if recording and curRec == (voice-1) then
  -- DO NOTHING
  print('not flipping on purpose')
  elseif v == nil then
    tV = voice
    softcut.rate(tV,rate[dir])
    scRte[tV] = rate[dir]
  elseif not(v == nil) then
    tV = v
    scRte[tV] = scRte[tV]*(-1)
    softcut.rate(tV,scRte[tV])
    --scRte[tV] = rate[dir]
  end
  
 
  flipper.time = math.random(1,fTime)
  print(tV,rate[dir],'dir')
  
end

function flop(v)
  
  shuffle(scPan)
  
  for i = 1, #scPan do
    --tV = voice
    softcut.pan(i,scPan[i])
     print(i,scPan[i],'pan')
  end
  flopper.time = math.random(1,fTime)
end

function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i] , tbl[j] = tbl[j] , tbl[i]
  end
end

function updateLoops(v,t)
  lEnd[v] = math.min(t,49) 
  loopTimer[v].time = lEnd[v]/(lEnd[v]+6)
 
  softcut.loop_end(v,  lEnd[v] + lStart[v])
  
end

function key (n,z)
  
  if n == 2 and z == 1 then
    
    curRec = (curRec - 1) % 6
    ft.setVoice(curRec + 1)
    print(curRec + 1)
    
  end
  
   if n == 3 and z == 1 then
    
    curRec = (curRec + 1) % 6
    ft.setVoice(curRec + 1)
    print(curRec + 1)
    
  end
  
  
end

function enc (n,d)

  if n == 3 then
    scPre[curRec + 1] = util.clamp(scPre[curRec + 1] + (d * 0.01),0,1)
    sc.setPre(curRec+1,scPre[curRec+1])
    --params:set(encPre[curRec+1], scPre[curRec+1])
    print(scPre[curRec+1])
    --redraw()
  end

end

function refresh()
  redraw()
end
function redraw()
  screen.clear()
  ---------------------
  ------------------------------------------
  ---------------------
  -- recording selected
  screen.level(16)
  screen.rect(4+recRec,4,18,56)
  screen.fill()
  ---------------------
  ------------------------------------------
  ---------------------
  -- voice 1
  screen.level(math.ceil(dVlevel[1]))
  screen.rect(7,6,14,52)
  screen.fill()
  ---------------------
  ---------------------
  screen.level(0)
  screen.line_width(3)
  screen.move(7,lEnd[1]+6)
  screen.line(21,lEnd[1]+6)
  screen.stroke(2)
  ---------------------
  -- falling line
  screen.level(0)
  screen.line_width(1)
  screen.move(7,fall[1]+7)
  screen.line(21,fall[1]+7)
  screen.stroke(2) 
  ----------------------
  -- voice PRE
  screen.level(math.ceil(scPre[1]*16))
  --screen.rect(7,20,14,38)
  screen.rect(7,lEnd[1]+6,14,52-(lEnd[1]+6)+6)
  screen.fill()
  ---------------------
  ------------------------------------------
  ---------------------
  -- voice 2
  screen.level(math.ceil(dVlevel[2]))
  screen.rect(26,6,14,52)
  screen.fill()
  ---------------------
  ---------------------
  screen.level(0)
  screen.line_width(3)
  screen.move(26,lEnd[2]+6)
  screen.line(40,lEnd[2]+6)
  screen.stroke(2)
  ---------------------
  ---------------------
  -- falling line
  screen.level(0)
  screen.line_width(1)
  screen.move(26,fall[2]+7)
  screen.line(40,fall[2]+7)
  screen.stroke(2) 
  ----------------------
  -- voice PRE
  screen.level(math.ceil(scPre[2]*16))
  --screen.rect(26,24,14,34)
  screen.rect(26,lEnd[2]+6,14,52-(lEnd[2]+6)+6)
  screen.fill()
  ---------------------
  ------------------------------------------
  ---------------------
  -- voice 3
  screen.level(math.ceil(dVlevel[3]))
  screen.rect(46,6,14,52)
  screen.fill()
  ---------------------
  ---------------------
  screen.level(0)
  screen.line_width(3)
  screen.move(46,lEnd[3]+6)
  screen.line(60,lEnd[3]+6)
  screen.stroke(2)
  ---------------------
  ---------------------
  -- falling line
  screen.level(0)
  screen.line_width(1)
  screen.move(46,fall[3]+7)
  screen.line(60,fall[3]+7)
  screen.stroke(2) 
  ----------------------
  -- voice PRE
  screen.level(math.ceil(scPre[3]*16))
  --screen.rect(46,30,14,28)
  screen.rect(46,lEnd[3]+6,14,52-(lEnd[3]+6)+6)
  screen.fill()
  ---------------------
  ------------------------------------------
  ---------------------
  -- voice 4
  screen.level(math.ceil(dVlevel[4]))
  screen.rect(66,6,14,52)
  screen.fill()
  ---------------------
  ---------------------
  screen.level(0)
  screen.line_width(3)
  screen.move(66,lEnd[4]+6)
  screen.line(80,lEnd[4]+6)
  screen.stroke(2)
  ---------------------
  ---------------------
  -- falling line
  screen.level(0)
  screen.line_width(1)
  screen.move(66,fall[4]+7)
  screen.line(80,fall[4]+7)
  screen.stroke(2) 
  ---------------------
  -- voice PRE
  screen.level(math.ceil(scPre[4]*16))
  --screen.rect(66,36,14,22)
  screen.rect(66,lEnd[4]+6,14,52-(lEnd[4]+6)+6)
  screen.fill()
  ---------------------
  ------------------------------------------
  ---------------------
  -- voice 5
  screen.level(math.ceil(dVlevel[5]))
  screen.rect(86,6,14,52)
  screen.fill()
  ---------------------
  ---------------------
  screen.level(0)
  screen.line_width(3)
  screen.move(86,lEnd[5]+6)
  screen.line(100,lEnd[5]+6)
  screen.stroke(2)
  ---------------------
  ---------------------
  -- falling line
  screen.level(0)
  screen.line_width(1)
  screen.move(86,fall[5]+7)
  screen.line(100,fall[5]+7)
  screen.stroke(2) 
  ---------------------
  -- voice PRE
  screen.level(math.ceil(scPre[5]*16))
  --screen.rect(86,42,14,16)
  screen.rect(86,lEnd[5]+6,14,52-(lEnd[5]+6)+6)
  screen.fill()
  ---------------------
  ------------------------------------------
  ---------------------
   -- voice 6
  screen.level(math.ceil(dVlevel[6]))
  screen.rect(106,6,14,52)
  screen.fill()
  ---------------------
  ---------------------
  screen.level(0)
  screen.line_width(3)
  screen.move(106,lEnd[6]+6)
  screen.line(120,lEnd[6]+6)
  screen.stroke(2)
  ---------------------
  ---------------------
  -- falling line
  screen.level(0)
  screen.line_width(1)
  screen.move(106,fall[6]+7)
  screen.line(120,fall[6]+7)
  screen.stroke(2) 
  ---------------------
  -- voice PRE
  screen.level(math.ceil(scPre[6]*16))
  --screen.rect(106,48,14,10)
  screen.rect(106,lEnd[6]+6,14,52-(lEnd[6]+6)+6)
  screen.fill()
  ---------------------
  ------------------------------------------
  ------------------------------------------
  ------------------------------------------
  ---------------------
  screen.update()
end

