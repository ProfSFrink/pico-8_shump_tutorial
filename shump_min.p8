pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function showDebugUI()?state,0,12
?#projectiles,0,123,7
?#enemyProjectiles,10,123,10
?#enemies,20,123,3
?#routines,30,123,15
?ship.x,0,63,7
?ship.y,0,70,7
?"i:"..ship.invul,110,113,7
?"wt:"..waveT,105,123,7
end function calcCenX(n)return(128-n*4)/2end function calcAngle(n,e,i,o)return atan2(o-e,i-n)end function ranInt(n,e)return flr(rnd(e-n+1))+n end function ranFloat(n,e)return rnd(e-n)+n end function switchSign(n)return-n end function blink()local n={5,5,5,5,5,5,5,5,5,5,6,6,7,7,6,5}if(blinkT>#n)blinkT=1
return n[blinkT]end function log(n,e)printh(n,"logs/log",e)end function showHitBox(n)end function getCentre(n)return{x=n.x+n.hitBox.offX+n.hitBox.w/2,y=n.y+n.hitBox.offY+n.hitBox.h/2}end function hasStoppedFiring()return btn(4)==false and btn(5)==false end function inBounds(n)return mid(0,n.x,128)==n.x and mid(0+uiHeight,n.y,128)==n.y end function doShake()local n,e=rnd(shake)-shake/2,rnd(shake)-shake/2camera(n,e)if(shake>10)shake*=.9else shake-=1if(shake<=1)shake=0
end _g=_ENV debugMode=false waveT=0pressAKey="PRESS Z OR X TO "uiHeight=8bullHeight=3blinkT=1hitDefault=7function _init()cls()routines={}shipStartX=61shipStartY=108waveNum=0shake=0stars={}numOfStars=80farStar={col=5,spd=.25}midStar={col=6,spd=.75,isAsteroid=false}nearStar={col=7,twinkleCol=10,spd=2}stateNames={title="title",start="start",newWave="newWave",game="game",win="win",gameOver="gameOver"}state=stateNames.title enterTitle()createStarfield(true)end function _update()if state==stateNames.game do updateGame()elseif state==stateNames.title do updateTitle()elseif state==stateNames.start do updateStart()elseif state==stateNames.newWave do updateNewWave()elseif state==stateNames.gameOver do updateGameOver()elseif state==stateNames.win do updateWin()end end function _draw()if state==stateNames.game do drawGameScene()elseif state==stateNames.title do drawTitle()elseif state==stateNames.start do drawStart()elseif state==stateNames.newWave do drawNewWave()elseif state==stateNames.gameOver do drawGameOver()elseif state==stateNames.win do drawWin()end doShake()end function hasCollided(n,e)local o,d,i,n=n.hitBox.w or hitDefault,n.hitBox.h or hitDefault,n.x+(n.hitBox.offX or 0),n.y+(n.hitBox.offY or 0)local l,d,t,f,o,e=i+o,n+d,e.hitBox.w or hitDefault,e.hitBox.h or hitDefault,e.x+(e.hitBox.offX or 0),e.y+(e.hitBox.offY or 0)local t,f=o+t,e+f if(n>f or e>d or i>t or o>l)return false
return true end function async(n)add(routines,cocreate(n))end function wait(n)for n=1,n do yield()end end function animate(i,o,d,n,e)local l=i[o]n=n or 30e=e or linear for t=1,n do i[o]=lerp(l,d,e(t/n))yield()end end function lerp(n,e,i)return n+(e-n)*i end function linear(n)return n end function easeOutQuad(n)n-=1return 1-n*n end function easeOutQuart(n)n-=1return 1-n*n*n*n end slSwCfg={r=2,tr=4,spd=1,col=9}lgSwCfg={r=2,tr=28,spd=3.5,col=7}function spawnShockWave(i,o,n)local e=shwaves local n={x=i+4,y=o+4,r=n.r,tr=n.tr,spd=n.spd,col=n.col,update=function(_ENV)r+=spd if(r>tr)del(e,_ENV)return
end,draw=function(_ENV)circ(x,y,r,col)end}add(e,n)end function updateShockWaves()for n in all(shwaves)do n:update()end end function drawShockWaves()for n in all(shwaves)do n:draw()end end numOfParts=50eneCols={5,9,10,7}shipCols={1,1,12,7}function newExpObj(e,i,o,n)local d=_g return{x=e+4,y=i+4,spdX=(rnd()-.5)*5,spdY=o+(rnd()-.5)*5,scale=ranFloat(1,4),life=ranFloat(1,4),maxLife=ranFloat(1,4),small=ranFloat(1,2)<=1.2,update=function(_ENV)x+=spdX y+=spdY if(small)spdX*=1spdY*=1else spdX*=.85spdY*=.85
scale-=.1life-=.1if life/maxLife<.25do col=n[1]elseif life/maxLife<.5do col=n[2]elseif life/maxLife<.75do col=n[3]else col=n[4]end if(life<=0)del(d.exps,_ENV)
end,draw=function(_ENV)if(small)pset(x,y,7)else circfill(x,y,scale,col)
end}end function newFlash(n,e,i,o,d)local l=exps return{x=n+4,y=e+4,scale=i,life=o,col=d,update=function(_ENV)life-=.5scale-=.5if(life<=0)del(l,_ENV)
end,draw=function(_ENV)circfill(x,y,scale,col)end}end function spawnExp(n,e,i,o)for d=1,numOfParts do add(exps,newExpObj(n,e,i,o))end add(exps,newFlash(n,e,8,4,7))sfx(1)end function updateExplosions()for n in all(exps)do n:update()end end function drawExplosions()for n in all(exps)do n:draw()end end function spawnSparks(i,o,n)local e=sparks local n={x=i+4,y=o+4,spdX=(rnd()-.5)*2,spdY=(rnd()-1)*2,col=n,life=ranFloat(1,3),update=function(_ENV)x+=spdX y+=spdY life-=.2if(life<=0)del(e,_ENV)return
end,draw=function(_ENV)pset(x,y,n)end}add(e,n)end function updateSparks()for n in all(sparks)do n:update()end end function drawSparks()for n in all(sparks)do n:draw()end end function newStar(o,d,n)local l,n,n,n,e,i=n and 0or uiHeight,midStar,farStar,nearStar,rnd,flr return{x=i(e(118)+10),y=i(e(118)+10),col=o,spd=d,update=function(_ENV)y+=spd if(y>128)y=l x=i(e(128))
if col==n.col do col=n.twinkleCol elseif col==n.twinkleCol do col=n.col end end}end function createStarfield(i)for o=1,numOfStars do local e,n=flr(rnd(3))+5if e==farStar.col do n=farStar.spd elseif e==midStar.col do n=midStar.spd else n=nearStar.spd end stars[o]=newStar(e,n,i)end end function updateStarfield()for n in all(stars)do n:update()end end function drawStarfield()for n in all(stars)do pset(n.x,n.y,n.col)end end local e,n={[10]=7,[7]=6,[6]=5,[5]=0,[0]=0},0function fadeOutStarfield()n+=1if(n>=13)n=0for n in all(stars)do n.col=e[n.col]or 0end
for n in all(stars)do pset(n.x,n.y,n.col)end end yellowBullet="yellowBullet"yellowLaser="yellowLaser"yellowBlaster="yellowBlaster"pinkBullet="pinkBullet"blueBullet="blueBullet"pTypes={yellowBullet={ani={start=16,fin=17,delay=5},hitBox={w=1,h=1,offX=2,offY=2},animate=function(_ENV)if(curSpr<ani.fin)curSpr+=1else curSpr=ani.start
end},yellowLaser={ani={start=35,fin=38,delay=6},hitBox={w=2,h=5,offX=1,offY=1},animate=function(_ENV)if(curSpr<ani.fin)curSpr+=1else curSpr=ani.start
end},yellowBlaster={ani={start=19,fin=19,delay=0},hitBox={w=3,h=6,offX=1,offY=0},animate=function(_ENV)if(curSpr<ani.fin)curSpr+=1else curSpr=ani.start
end},pinkBullet={ani={start=32,fin=34,delay=5},hitBox={w=1,h=1,offX=2,offY=2},animate=function(_ENV)if(curSpr<ani.fin)curSpr+=1else curSpr=ani.start
end},blueBullet={ani={start=48,fin=50,delay=5},hitBox={w=1,h=1,offX=2,offY=2},animate=function(_ENV)if(curSpr<ani.fin)curSpr+=1else curSpr=ani.start
end}}owner={player="player",enemy="enemy"}function newProjectile(n,d,l,i,o,t,f)local e=_g return{x=d+2,y=l,spd=o,ang=i,xSpd=e.sin(i)*o,ySpd=e.cos(i)*o,owner=f,dam=t or 1,hitBox={w=n.hitBox.w or hitDefault,h=n.hitBox.h or hitDefault,offX=n.hitBox.offX or 0,offY=n.hitBox.offY or 0},animate=n.animate,curSpr=n.ani.start,ani=n.ani,animTimer=0,animDelay=n.ani.delay,update=function(_ENV)x+=xSpd y+=ySpd animTimer+=1if(animTimer>=animDelay)animTimer=0animate(_ENV)
if(x<0or x>128or y<e.uiHeight-e.bullHeight or y>128)e.removeProjectile(_ENV)
end,draw=function(_ENV)spr(curSpr,x,y)if(e.debugMode)e.showHitBox(_ENV)
end}end function spreadShot(e,i,o,n,d,l,t,f)local l=l or 0for a=1,n do addProjectile(newProjectile(e,i,o,1/n*a+l,d,t,f))end end function directedSpreadShot(i,o,d,n,l,e,t,f)local a=e or.25for e=1,n do local e=(e-1)/(n-1)-.5if(n==1)e=0
local n=a+e*.15addProjectile(newProjectile(i,o,d,n,l,t,f))end end function aimedSpreadShot(o,n,e,d,l,t,f)local i=getCentre(ship)local i=calcAngle(n,e,i.x,i.y)directedSpreadShot(o,n,e,d,l,i,t,f)end function singleShot(n,e,i,o,d,l,t)addProjectile(newProjectile(n,e,i,o,d,l,t))end function aimedSingleShot(o,n,e,d,l,t)local i=getCentre(ship)ang=calcAngle(n,e,i.x,i.y)addProjectile(newProjectile(o,n,e,ang,d,l,t))end function aimedMultiShot(o,n,e,d,l,t,f)local i=getCentre(ship)local i=calcAngle(n,e,i.x,i.y)for d=1,d do addProjectile(newProjectile(o,n,e,i,l+d*.5,t,f))end end function getProConfig(n)return pTypes[n]end function addProjectile(n)if(n.owner==owner.player)add(projectiles,n)else add(enemyProjectiles,n)
end function removeProjectile(n)if(n.owner==owner.player)del(projectiles,n)else del(enemyProjectiles,n)
end function removeAllProjectiles()for n in all(projectiles)do del(projectiles,n)end for n in all(enemyProjectiles)do del(enemyProjectiles,n)end end function updateProjectiles()for n in all(projectiles)do n:update()end for n in all(enemyProjectiles)do n:update()end end function drawProjectiles()for n in all(projectiles)do n:draw()end for n in all(enemyProjectiles)do n:draw()end end function fireSingleShot(e,i,n)local o=getProConfig(n.pCfg)singleShot(o,e,i,ship.ang,n.spd,n.dam,owner.player)sfx(n.sfx)end function fireSpreadShot(e,i,n)local o=getProConfig(n.pCfg)directedSpreadShot(o,e,i,n.num,n.spd,n.ang,n.dam,owner.player)sfx(n.sfx)end function getWepConfig(n)return weapons[n]end singleBullet="singleBullet"singleLaser="singleLaser"blastShot="blastShot"threeShotBullet="threeShotBullet"weapons={singleBullet={pCfg=yellowBullet,spd=3,dam=1,rof=4,sfx=0,fireFunc=fireSingleShot},singleLaser={pCfg=yellowLaser,spd=4,dam=2,rof=8,sfx=2,fireFunc=fireSingleShot},blastShot={pCfg=yellowBlaster,spd=3,dam=4,rof=12,sfx=33,fireFunc=fireSingleShot},threeShotBullet={pCfg=yellowBullet,spd=3,dam=1,rof=6,num=3,ang=.5,sfx=0,fireFunc=fireSpreadShot}}redCherry="redCherry"pickUpTypes={redCherry={wep=threeShotBullet,curSpr=54}}function newPickUp(n,i,o)local e=_g return{wep=n.wep,curSpr=n.curSpr,x=i,y=o,hitBox={w=hitDefault,h=hitDefault,offX=0,offY=0},update=function(_ENV)x+=1y+=1end,draw=function(_ENV)spr(curSpr,x,y)if(e.debugMode)e.showHitBox(_ENV)
end}end function getPickUpConfig(n)return pickUpTypes[n]end function addPickUp(n,e,i)local n=getPickUpConfig(n)add(pickups,newPickUp(n,e,i))end function removePickUp(n)del(pickups,n)end function updatePickUps()for n in all(pickups)do n:update()end end function drawPickUps()for n in all(pickups)do n:draw()end end function newShip()local n=_ENV return{x=n.shipStartX,y=n.shipStartY,xMaxSpeed=2,yMaxSpeed=2,xSpeed=0,ySpeed=0,hitBox={w=3,h=2,offX=2,offY=4},startSprite=3,sprite=3,flameStartSprite=7,flameEndSprite=11,flameSprite=7,bulletOffset=3,ang=.5,rof=0,muzzle=0,weaponOne=singleBullet,weaponTwo=nil,invul=0,deathTimer=30,move=function(_ENV,n)if n=="left"do sprite=1xSpeed=-xMaxSpeed elseif n=="right"do sprite=5xSpeed=xMaxSpeed elseif n=="up"do sprite=startSprite ySpeed=-yMaxSpeed elseif n=="down"do sprite=startSprite ySpeed=yMaxSpeed end end,hit=function(_ENV)n.sfx(1)if(n.player.lives<=0)invul=30n.spawnExp(x,y,0,n.shipCols)n.spawnShockWave(x,y,n.lgSwCfg)else invul=60
end,reset=function(_ENV)sprite=startSprite xSpeed=0ySpeed=0end,isDead=function(_ENV)deathTimer-=1if(deathTimer<=0)return true else return false
end,canCollide=function(_ENV)return n.state~=n.stateNames.newWave and n.inBounds(_ENV)end,update=function(_ENV)x+=xSpeed y+=ySpeed x=mid(0,x,120)y=mid(0+n.uiHeight,y,120)if(invul>0)invul-=1
flameSprite+=1if(flameSprite>flameEndSprite)flameSprite=flameStartSprite
if(muzzle>=0)muzzle-=1
end,draw=function(_ENV,e)if(invul<=0)spr(sprite,x,y)spr(flameSprite,x,y+8)else if(sin(e/5)<.1)pal(2,6)spr(sprite,x,y)spr(flameSprite,x,y+8)pal()
circfill(x+3,y-2,muzzle,7)circfill(x+4,y-2,muzzle,7)if(n.debugMode)n.showHitBox(_ENV)
end}end function stationary(n)end function down(n)n.y+=n.ySpd end function downWave(n,e)n.xSpd=sin(e/n.waveLen)if(n.x<32)n.xSpd+=1-n.x/32
if(n.x>88)n.xSpd-=(n.x-88)/32
n.x+=n.xSpd n.y+=n.ySpd end function leftRight(n)if(n.x<12)n.xSpd=switchSign(n.xSpd)
if(n.x>116)n.xSpd=switchSign(n.xSpd)
n.x+=n.xSpd end function leftRightUpDown(n)if(n.x<12)n.xSpd=switchSign(n.xSpd)
if(n.x>116)n.xSpd=switchSign(n.xSpd)
if(n.y<10)n.ySpd=switchSign(n.ySpd)
if(n.y>65)n.ySpd=switchSign(n.ySpd)
n.x+=n.xSpd n.y+=n.ySpd end function downWaveSlow(n)n.x+=cos(n.y/32)*n.xSpd n.y+=n.ySpd/2end function downTowardCenter(n)local e=atan2(64-n.x,140-n.y)n.x+=cos(e)*n.xSpd n.y+=sin(e)*n.ySpd end function downAcross(n)if n.xSpd==0do n.ySpd=n.spd if ship.y<=n.y do n.ySpd=0if(ship.x<n.x)n.xSpd-=n.spd else n.xSpd+=n.spd
n:fire()end end n.x+=n.xSpd n.y+=n.ySpd end function downTowardCenterBackUp(n)if(not n.moveSwitch and n.y>70)n.moveSwitch=true if(ship.x<63)n.ang=calcAngle(n.x,n.y,0,0)else n.ang=calcAngle(n.x,n.y,128,0)
if(n.moveSwitch)n.x+=sin(n.ang)*n.xSpd
n.y+=cos(n.ang)*n.spd end alien="alien"ufo="ufo"eyeball="eyeball"redeye="redeye"flame="flame"fighter="fighter"boss="boss"eDefs={alien={name=alien,cols={{c1=11,c2=3},{c1=9,c2=4},{c1=10,c2=9},{c1=8,c2=2},{c1=6,c2=13}},hitBox={w=7,h=5,offX=0,offY=1},ani={80,81,82,83},flash=84,aniDelay=.4,xSpd=0,ySpd=1,movements={normal=stationary,onHit=stationary},move=stationary,hp=1,rof=60,dam=1,ang=1,pSpd=2,points=100},ufo={name=ufo,cols={{c1=12,c2=1},{c1=9,c2=4},{c1=11,c2=3},{c1=8,c2=2},{c1=14,c2=2}},hitBox={w=5,h=3,offX=1,offY=3},ani={64,65,66,67},flash=68,aniDelay=.4,spd=.8,xSpd=.8,ySpd=.8,movements={normal=leftRight,onHit=downWaveSlow},move=leftRight,hp=2,rof=45,dam=2,ang=.875,pSpd=1,points=175},eyeball={name=eyeball,cols={{c1=8,c2=2},{c1=9,c2=4},{c1=11,c2=3},{c1=12,c2=1},{c1=14,c2=2}},hitBox={w=5,h=5,offX=1,offY=1},ani={69,70,71,72},flash=73,aniDelay=.4,xSpd=.2,ySpd=.4,movements={normal=downWave,onHit=downWave},move=downWave,hp=2,rof=20,dam=1,ang=.5,points=150},redeye={name=redeye,cols={{c1=5,c2=8},{c1=9,c2=4},{c1=11,c2=3},{c1=12,c2=1},{c1=14,c2=2}},hitBox={w=4,h=4,offX=1,offY=1},ani={88,89,90,91,92},flash=93,aniDelay=.4,spd=1.25,xSpd=1.5,ySpd=1.2,movements={normal=stationary,onHit=stationary},move=stationary,hp=4,rof=60,dam=1,pSpd=.8,points=200},flame={name=flame,cols={{c1=8,c2=2},{c1=9,c2=4},{c1=11,c2=3},{c1=12,c2=1},{c1=14,c2=2}},hitBox={w=5,h=4,offX=1,offY=3},ani={85,86},flash=87,aniDelay=.4,xSpd=1.4,ySpd=1,movements={normal=downWave,onHit=downWave},move=downWave,waveLen=30,hp=2,rof=45,dam=1,pSpd=1.4,points=200},fighter={name=fighter,cols={{c1=1,c2=5},{c1=9,c2=4},{c1=11,c2=3},{c1=12,c2=1},{c1=14,c2=2}},hitBox={w=5,h=4,offX=1,offY=1},ani={74,75,76,77},flash=78,aniDelay=.4,spd=1.5,xSpd=0,ySpd=2,movements={normal=downAcross,onHit=downAcross},move=downAcross,hp=2,rof=20,dam=1,pSpd=2.5,points=300},boss={name=boss,cols={{c1=6,c2=14},{c1=9,c2=4},{c1=11,c2=3},{c1=12,c2=1},{c1=14,c2=2}},hitBox={w=11,h=9,offX=2,offY=4},bullXOffset=4,bullYOffset=12,sprSize=2,ani={96,98},flash=100,aniDelay=.4,xSpd=-.5,ySpd=.35,movements={normal=leftRight,onHit=leftRight},move=leftRight,hp=40,rof=10,dam=1,points=1000}}local i={spawning="spawning",stopped="stopped",flashing="flashing",attacking="attacking",dead="dead"}function newEnemy(e,o,d,l,t)local n=_g return{name=e.name,x=o,y=d,rowNum=l,activateAt=t or 0,spd=e.spd or 0,xSpd=e.xSpd,ySpd=e.ySpd,movements={normal=e.movements.normal,onHit=e.movements.onHit},move=e.movements.normal,waveLen=e.waveLen or 45,hitBox={w=e.hitBox.w or hitDefault,h=e.hitBox.h or hitDefault,offX=e.hitBox.offX or 0,offY=e.hitBox.offY or 0},bullXOffset=e.bullXOffset or-1,bullYOffset=e.bullYOffset or 6,hp=e.hp or 1,rof=e.rof,dam=e.dam,ang=e.ang or 1,pSpd=e.pSpd or 1,moveDelay=0,shakeTimer=0,points=e.points,moveSwitch=false,colId=1,cols=e.cols,sprSize=e.sprSize or 1,ani=e.ani,flashSpr=e.flash,curSpr=e.ani[1],aniFrame=1,aniDelay=e.aniDelay,fireDelay=10,flashTimer=3,deathTimer=10,state=i.spawning,activate=function(_ENV)state=i.stopped end,animate=function(_ENV)aniFrame+=aniDelay if(flr(aniFrame)>#ani)aniFrame=1
curSpr=ani[flr(aniFrame)]end,fire=function(_ENV)local i,e=n.getProConfig(n.pinkBullet),{x=x+bullXOffset,y=y+bullYOffset}if name==n.boss do n.spreadShot(i,e.x,e.y,8,1.3,0,dam,n.owner.enemy)elseif name==n.ufo do n.aimedSpreadShot(i,e.x,e.y,3,2,dam,n.owner.enemy)elseif name==n.flame or name==n.fighter do local i=n.getProConfig(n.blueBullet)n.aimedSingleShot(i,e.x,e.y,pSpd,dam,n.owner.enemy)elseif name==n.redeye do local i=n.getProConfig(n.blueBullet)n.aimedMultiShot(i,e.x,e.y,2,pSpd,dam,n.owner.enemy)else n.singleShot(i,e.x,e.y,ang,pSpd,dam,n.owner.enemy)end end,attack=function(_ENV)fireDelay-=1moveDelay-=1if(fireDelay>0and fireDelay<=3)curSpr=flashSpr
if(moveDelay<=0)move(_ENV,n.gameT)if(fireDelay<=0)fire(_ENV)fireDelay=rof+n.ranInt(1,4)n.sfx(29)
end,shake=function(_ENV)if(state~=i.stopped)return
aniDelay*=3moveDelay=15shakeTimer=20state=i.attacking end,hit=function(_ENV,e)if(state==i.spawning or state==i.dead)return
hp-=e or hp n.sfx(3)if hp<=0do if(state==i.attacking)points+=n.flr(points*.3)
state=i.dead eCentre=n.getCentre(_ENV)n.player.score+=points n.spawnExp(eCentre.x,eCentre.y,ySpd,n.eneCols)n.spawnShockWave(eCentre.x,eCentre.y,n.lgSwCfg)else state=i.flashing end end,flash=function(_ENV)curSpr=flashSpr flashTimer-=1if(flashTimer<=0)flashTimer=3move=movements.onHit state=i.attacking
end,dead=function(_ENV)curSpr=flashSpr deathTimer-=1if(deathTimer<=0)del(n.enemies,_ENV)
end,canCollide=function(_ENV)return state~=i.dead and state~=i.spawning and n.inBounds(_ENV)end,update=function(_ENV)if state==i.dead do dead(_ENV)elseif state==i.flashing do flash(_ENV)elseif state==i.spawning do animate(_ENV)elseif state==i.stopped do animate(_ENV)elseif state==i.attacking do animate(_ENV)attack(_ENV)end if(state~=i.spawning)if(x<-25or x>153or y>153)del(n.enemies,_ENV)
end,draw=function(_ENV)pal(cols[1].c1,cols[colId].c1)pal(cols[1].c2,cols[colId].c2)local e=x if(shakeTimer>0)shakeTimer-=1if(n.gameT%4<2)e+=1
if(state==i.dead)spr(curSpr,x,y,sprSize,sprSize,false,deathTimer%2==0)else spr(curSpr,e,y,sprSize,sprSize)
if(n.debugMode)n.showHitBox(_ENV)
pal()end}end function spawnEnemy(n,e,i,o,d)local n=newEnemy(n,e,i,o,d)add(enemies,n)return n end function updateEnemies()for n in all(enemies)do n:update()end end function drawEnemies()for n in all(enemies)do n:draw()end end function updateGameScene()gameT+=1ship.rof-=1ship:reset()if(btn(0)and canPlay)ship:move("left")
if(btn(1)and canPlay)ship:move("right")
if(btn(2)and canPlay)ship:move("up")
if(btn(3)and canPlay)ship:move("down")
if(btn(4)and canPlay)if(ship.rof<=0and ship.weaponOne~=nil)local n=getWepConfig(ship.weaponOne)n.fireFunc(ship.x,ship.y-ship.bulletOffset,n)ship.rof=n.rof ship.muzzle=4
if(btn(5)and canPlay and ship.weaponTwo~=nil)if(ship.rof<=0)local n=getWepConfig(ship.weaponTwo)n.fireFunc(ship.x,ship.y-ship.bulletOffset,n)ship.rof=n.rof ship.muzzle=4
for n in all(routines)do if(costatus(n)=="dead")del(routines,n)else coresume(n)
end ship:update()updateStarfield()updateProjectiles()updateShockWaves()updateSparks()updateExplosions()for n in all(enemies)do n:update()if n:canCollide()do for e in all(projectiles)do if(hasCollided(n,e))n:hit(e.dam)local i,n=getCentre(e),getCentre(n)spawnShockWave(i.x,i.y,slSwCfg)spawnSparks(n.x,n.y,7)removeProjectile(e)
end if(hasCollided(n,ship)and ship.invul<=0)player.lives-=1n:hit()ship:hit()shake=6
end end for n in all(enemyProjectiles)do if(ship:canCollide())if(hasCollided(n,ship)and ship.invul<=0)player.lives-=1ship:hit()shake=6removeProjectile(n)
end end function drawGameScene()cls()drawStarfield()if(debugMode)showDebugUI()
drawSparks()drawShockWaves()drawExplosions()if(player.lives>0)ship:draw(gameT)
drawEnemies()drawProjectiles()rectfill(0,0,127,uiHeight,1)local n="SCORE: "..player.score?n,calcCenX(#n),2,12
local n=0for e=1,4do n=e*9-8if(player.lives>=e)spr(13,n,1)else spr(14,n,1)
end end function updateTitle()blinkT+=1if(btnp(4)or btnp(5))enterStart()
updateStarfield()end function drawTitle()cls(0)drawStarfield()local n,e="MY FIRST SHUMP!",pressAKey.."START"?n,calcCenX(#n)+1,41,1
?n,calcCenX(#n),40,10
?e,calcCenX(#e),80,blink()
end function enterTitle()state=stateNames.title waveNum=0music(7)setupGame()end function updateStart()blinkT+=1if(btnp(4)or btnp(5))enterNewWave()
end function drawStart()cls(0)startTimer+=1local n,e="PLAYER 1 START","GET READY"?n,calcCenX(#n)+1,41,1
?n,calcCenX(#n),40,8
?e,calcCenX(#e),60,blink()
if(startTimer>60)enterNewWave()
end function enterStart()state=stateNames.start canPlay=false startTimer=0music(-1,2000)end local n=0function updateNewWave()blinkT+=1n-=1updateGameScene()if(n<=0)enterGame()return
end function drawNewWave()drawGameScene()local n="WAVE "..waveNum?n,calcCenX(#n),30,blink()
end function enterNewWave()state=stateNames.newWave canPlay=false n=50removeAllProjectiles()async(function()animate(ship,"x",shipStartX,60,easeOutQuad)end)async(function()animate(ship,"y",shipStartY,60,easeOutQuad)end)waveNum+=1if(waveNum==2or waveNum==4or waveNum==5)ship.weaponTwo=threeShotBullet
if(waveNum==3)ship.weaponTwo=blastShot
if(waveNum==1)music(0)else music(3)
end spawnEvents={{"1","-8,14,alien:140,alien:160,alien:210,gap,alien:210,gap,alien:210,alien:160,alien:140","136,34,alien:180,alien:210,alien:240,alien:240,alien:210,alien:180","136,34,alien:65,alien:70,gap,gap,alien:95,alien:95,gap,gap,alien:70,alien:65"},{"2","-8,14,alien:90,alien:100,gap,gap,flame:200,flame:200,gap,gap,alien:100,alien:90","136,34,alien:110,alien:125,gap,flame:155,flame:155,gap,alien:125,alien:110","64,-12,alien:120,alien:150,alien:60,alien:150,alien:150,alien:150,alien:120"},{"3","-8,14,redeye:30,gap,gap,gap,gap,redeye:120","136,34,flame:125,gap,gap,gap,gap,gap,gap,gap,gap,flame:125","64,-12,alien:45,alien:55,alien:60,gap,gap,alien:60,alien:55,alien:45"},{"4","-8,14,ufo:150,gap,ufo:180,gap,ufo:190","136,34,fighter:60,gap,gap,gap,redeye:130,redeye:130,gap,gap,gap,fighter:75","64,-12,alien:130,alien:125,alien:120,alien:115,alien:110"},{"5","-8,14,ufo:200,gap,ufo:200,gap,ufo:200","136,34,fighter:120,alien:45,alien:47,gap,ufo:200,gap,alien:45,alien:47,fighter:200","136,50,alien:35,alien:37,gap,redeye:150,redeye:150,redeye:150,redeye:150,redeye:130,gap,alien:37,alien:35"},{"6","-8,14,boss:45","136,34,ufo:240,gap,alien:40,alien:40,gap,alien:40,alien:40,gap,ufo:240","-8,54,redeye:30,alien:140,alien:120,redeye:30,alien:120,alien:140,redeye:30","136,74,gap,gap,alien:140,alien:120,alien:100,alien:120,alien:140,gap,gap"}}function setupGame()gameT=0spawnDur=40attackDur=40ship=newShip()player={score=0,lives=4,bombs=2,rof=0}projectiles={}enemyProjectiles={}enemies={}pickups={}exps={}sparks={}shwaves={}createStarfield(false)end function parseWaveRow(n)local n,e=split(n,","),{}for i=3,#n do local n=n[i]if(n=="gap")add(e,"gap")else local n=split(n,":")add(e,{def=eDefs[n[1]],activateAt=tonum(n[2])})
end return{x=tonum(n[1]),y=tonum(n[2]),rowEnemies=e}end function getWaveData(e)for n=1,#spawnEvents do if(tonum(spawnEvents[n][1])==e)return spawnEvents[n]
end end function hasWaveSpawnEvents(n)return getWaveData(n)~=nil end function spawnWaveRows(n)local n=getWaveData(n)if(not n)return
local o=#n-1for e=2,#n do local n,e,i=parseWaveRow(n[e]),e-1,nil for e,n in pairs(n.rowEnemies)do if(n~="gap")i=n break
end local i=i and i.def or nil local i=i and(i.hitBox.w or 7)or 7local d,l=max(11,i+4),(e-1)*10-(e-1)*(e-2)*2/2local i=(#n.rowEnemies-1)*d local t=flr(64-i/2)for i=1,#n.rowEnemies do local f,l=0+e*13,flr(l)if(n.rowEnemies[i]~="gap")local e=n.rowEnemies[i]local a,c,i=e.def.hitBox.offX or 0,e.def.hitBox.w or 7,t+(i-1)*d local i,n=flr(i-a-c/2),spawnEnemy(e.def,n.x,n.y,o,e.activateAt)async(function()wait(l)animate(n,"x",i,spawnDur,easeOutQuart)end)async(function()wait(l)animate(n,"y",f,spawnDur,easeOutQuart)end)
end o-=1end sfx(28)end function updateGame()updateGameScene()spawnT+=1waveT+=1if(spawnT==spawnDur)canPlay=true for n in all(enemies)do n:activate()end
if canPlay do for n in all(enemies)do if(waveT>=n.activateAt)n:shake()
end end if(#enemies==0)if(hasWaveSpawnEvents(waveNum+1))enterNewWave()return else enterWin()return
if(player.lives<=0)if(ship:isDead())enterGameOver()return
end function enterGame()state=stateNames.game spawnT=0spawnWaveRows(waveNum)waveT=-10end function updateGameOver()blinkT+=1if not readyForInput do if(hasStoppedFiring())readyForInput=true
return end if(btnp(4)or btnp(5))exitGameOver()
end function drawGameOver()drawGameScene()startTimer+=1fadeOutStarfield()if startTimer>=50do if(bg.x1<0and bg.x2>128)cls(bgCol)else bg.x1-=7bg.y1-=7bg.x2+=7bg.y2+=7rectfill(bg.x1,bg.y1,bg.x2,bg.y2,bgCol)
local n,e="GAME OVER",pressAKey.."RESTART"?n,calcCenX(#n),50,7
?e,calcCenX(#e),80,blink()
end end function enterGameOver()state=stateNames.gameOver readyForInput=false bg={x1=64,y1=64,x2=64,y2=64}bgCol=8startTimer=0music(6)end function exitGameOver()enterTitle()createStarfield(true)end function updateWin()blinkT+=1if not readyForInput do if(hasStoppedFiring())readyForInput=true
return end if(btnp(4)or btnp(5))enterTitle()
end function drawWin()drawGameScene()local n,e="YOU WIN!",pressAKey.."RESTART"?n,calcCenX(#n)+1,41,1
?n,calcCenX(#n),40,10
?e,calcCenX(#e),80,blink()
end function enterWin()state=stateNames.win readyForInput=false music(4)end
__gfx__
00000000000220000002200000022000000220000002200000000000000000000000000000000000000000000000000000000000088008800880088000000000
0000000000288200002882000028820000288200002882000000000000077000000770000007700000c77c000007700000000000888888888008800800000000
0070070000288200002882000028820000288200002882000000000000c77c000007700000c77c000cccccc000c77c0000000000888888888000000800000000
0007700002e88e2002e88e2002e88e2002e88e2002e88e200000000000cccc00000cc00000cccc0000cccc0000cccc0000000000888888888000000800000000
00077000027c88200e7c88e22e87c8e22e88c7e002887c2000000000000cc000000cc000000cc00000000000000cc00000000000088888800800008000000000
0070070002118820081188822881188228881180028811200000000000000000000cc00000000000000000000000000000000000008888000080080000000000
00000000025582200255882002855820028855200228552000000000000000000000000000000000000000000000000000000000000880000008800000000000
00000000002992000029920000299200002992000029920000000000000000000000000000000000000000000000000000000000000000000000000000000000
00aa000000aa0000007700000999900000000000000000000000000000000000000000000000000000000000000000000000000051ddd1500000000000000000
0a44a0000a99a00007cc7000997799000000000000000000000000000000000000000000000000000000000000000000000000005d999d500000000000000000
a4a94a00a97a9a007c77c7009a77a90000000000000000000000000000000000000000000000000000000000000000000000000059ddd9500000000000000000
a4994a00a9aa9a007c77c7009a77a90000000000000000000000000000000000000000000000000000000000000000000000000059999d500000000000000000
0a44a0000a99a00007cc70009a77a90000000000000000000000000000000000000000000000000000000000000000000000000089ddd9800000000000000000
00aa000000aa00000077000099aa990000000000000000000000000000000000000000000000000000000000000000000000000059ddd9500000000000000000
00000000000000000000000009aa900000000000000000000000000000000000000000000000000000000000000000000000000089999d800000000000000000
00000000000000000000000000990000000000000000000000000000000000000000000000000000000000000000000000000000500000500000000000000000
00ee000000ee00000077000001110000011100000111000001110000000000000000000000000000000000000000000000000000000000000000000000000000
0e22e0000e88e00007cc700019991000155510001555100015551000000000000000000000000000000000000000000000000000000000000000000000000000
e2e82e00e87e8e007c77c7001aaa1000199910001555100015551000000000000000000000000000000000000000000000000000000000000000000000000000
e2882e00e8ee8e007c77c7001aaa1000199910001999100015551000000000000000000000000000000000000000000000000000000000000000000000000000
0e22e0000e88e00007cc70001aaa10001aaa10001999100019991000000000000000000000000000000000000000000000000000000000000000000000000000
00ee000000ee0000007700001aaa10001aaa10001aaa100019991000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000001110000011100000111000001110000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cc000000cc00000077000000000000000000000000000000033330000000000000000000000000000000000000000000000000000000000000000000000000
0c11c0000cddc00007cc700000000000000000000000000000030300000000000000000000000000000000000000000000000000000000000000000000000000
c1cd1c00cd7cdc007c77c70000000000000000000000000000300300000000000000000000000000000000000000000000000000000000000000000000000000
c1dd1c00cdccdc007c77c70000000000000000000000000000300300000000000000000000000000000000000000000000000000000000000000000000000000
0c11c0000cddc00007cc700000000000000000000000000008808800000000000000000000000000000000000000000000000000000000000000000000000000
00cc000000cc0000007700000000000000000000000000008e880880000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000088880880000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000008808800000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000020000200200002002000020020000200700007000d89d000018910000189100001981000077770000000000
0001100000011000000110000001100000077000022ff220022ff220022ff220022ff220077777700d5115d000d515000011110000515d000777777000000000
001cc100001cc100001cc100001cc1000077770002ffff2002ffff2002ffff2002ffff2007777770d51aa15d0151a11000155100011a15107777777700000000
01cccc1001cccc1001cccc1001cccc10077777700077d7000077d700007d77000077d70000777700d51aa15d0d51a15000d55d00051a15d07777777700000000
1c6cc6c11c6cc6c11c6cc6c11c6cc6c17777777708577580085775800857758008577580077777706d5005d6065005d0006dd6000d5005607770077700000000
cccccccccccccccccccccccccccccccc77777777080550800805508008055080080550800707707066d00d60006d0d600066660006d0d6007770077000000000
01a11a100a1111a001a11a10011aa110077777700c0000c007c007c007c00c7007c007c007700770076006700066060000066000006066000770077000000000
001001000100001000100100000110000070070000c7c7000007c0000077cc000007c00000077000007007000007070000077000007070000070070000000000
03300330033003300330033003300330077007702000000202000020700000070066600000666000006660000068600000888000007770000000000000000000
33b33b3333b33b3333b33b3333b33b33777777772200002222000022770000770555560005555600055856000588860008888800077777000000000000000000
3bbbbbb33bbbbbb33bbbbbb33bbbbbb3777777772222222222222222777777775555556055585560558885605882886088828880777777700000000000000000
3b7717b33b7717b33b7717b33b7717b3777777772822228228222282777777775555555055888550588288508822288088222880777777700000000000000000
0b7117b00b7117b00b7117b00b7117b0077777702888888228888882777777771555555015585550158885501882885088828880777777700000000000000000
00377300003773000037730000377300007777002878878228788782777777770155550001555500015855000188850008888800077777000000000000000000
03033030030330300303303003033030070770702888888208000080777777770011100000111000001110000018100000888000007770000000000000000000
03000030300000030300003003300330070000700800008000000000070000700000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000149aa94100000000012222100000000077777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00019777aa921000000029aaaa920000000777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d09a77a949920d00d0497777aa920d0070777777777707000000000000000000000000000000000000000000000000000000000000000000000000000000000
0619aaa9422441600619a77944294160077777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
07149a922249417006149a9442244160077777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
07d249aaa9942d7006d249aa99442d60077777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
067d22444422d760077d22244222d770077777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d666224422666d00d776249942677d0077777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
066d51499415d66001d1529749251d10077777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
0041519749151400066151944a151660007777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a001944a100a0000400149a4100400007007777770070000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000049a400090000a0000000000a00000000777700070000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000070000000000000000000000000000000000005555555555555555555555555555555502222220022222200222222002222220
000bb000000bb0000007700000077000000000000000000000000000000000000578875005788750d562465d0578875022e66e2222e66e2222e66e2222e66e22
006666000066660060666606606666060000000000000000000000000000000005624650d562465d05177150d562465d27761772277617722776177227716772
0566665065666656b566665bb566665b00000000000000000000000000000000d517715d051771500566865005177150261aa172216aa162261aa612261aa162
65637656b563765b056376500563765000000000000000000000000000000000056686500566865005d24d50056686502ee99ee22ee99ee22ee99ee22ee99ee2
b063360b006336000063360000633600000000000000000000000000000000005d5245d505d24d500505505005d24d5022299222229999222229922222299222
00633600006336000063360000633600000000000000000000000000000000005005500505055050050000500505505020999902020000202099990202999920
0006600000066000000660000006600000000000000000000000000000000000dd0000dd0dd00dd005dddd500dd00dd022000022022002202200002202200220
00ff880000ff88000000000000000000000000000000000000000000000000003350053303500530000000000000000000000000000000000000000000000000
0888888008888880000000000000000000000000000000000000000000000000330dd033030dd030005005000350053000000000000000000000000000000000
06555560076665500000000000000000000000000000000000000000000000003b8dd8b3338dd833030dd030030dd03003e33e300e33e330033e333003e333e0
6566665576555565000000000000000000000000000000000000000000000000032dd2300b2dd2b0038dd830338dd833e33e33e333e33e333e33e333e33e333e
57655576555776550000000000000000000000000000000000000000000000003b3553b33b3553b3033dd3300b2dd2b033300333333003333330033333300333
0655766005765550000000000000000000000000000000000000000000000000333dd333333dd33303b55b303b3553b3e3e3333bbe33333ebe3e333be3e3333b
0057650000655700000000000000000000000000000000000000000000000000330550330305503003bddb30333dd3334bbbbeb44bbbebb44bbbbeb44bbbebe4
00065000000570000000000000000000000000000000000000000000000000000000000000000000003553000305503004444440044444400444444004444440
0000000000000000000000000000000000000000002222000022220000222200002222000cccccc00c0000c00000000000000000000000000000000000000000
000000000000000000000000000000000000000002eeee2002eeee2002eeee2002eeee20c0c0c0ccc000000c0000000000000000000000000000000000000000
00000000000000000000000000000000000000002ee77ee22ee77ee22eeeeee22ee77ee2c022220ccc2c2c0cc022220c00222200000000000000000000000000
00000000000000000000000000000000000000002ee77ee22ee77ee22ee77ee22ee77ee2cc2cac0cc02aa20cc0cac2ccc02aa20c000000000000000000000000
00000000000000000000000000000000000000002eeeeee22eeeeee22eeeeee22eeeeee2c02aa20cc0cac2ccc02aa20ccc2cac0c000000000000000000000000
00000000000000000000000000000000000000002222222222222222222222222222222200222200c022220ccc2c2c0cc022220c000000000000000000000000
0000000000000000000000000000000000000000202020200202020220202020020202020000000000000000c000000cc0c0c0cc000000000000000000000000
00000000000000000000000000000000000000002000200002000200002000200002000200000000000000000c0000c00cccccc0000000000000000000000000
000880000009900000089000000890000000000001111110011111100000000000d89d0000189100001891000019810000005500000050000005000000550000
706666050766665000676600006656000000000001cccc1001cccc10000000000d5115d000d515000011110000515d0000055000000550000005500000055000
1661c6610161661000666600001666000000000001cccc1001cccc1000000000d51aa15d0151a11000155100011a151005555550055555500555555005555550
7066660507666650006766000066560000000000017cc710017cc71000000000d51aa15d0d51a15000d55d00051a15d022222222222222222222222222222222
0076650000766500007665000076650000000000017cc710017cc710000000006d5005d6065005d0006dd6000d50056026060602260606022666666226060602
000750000007500000075000000750000000000001111110011111100000000066d00d60006d0d600066660006d0d60020000002206060622222222020606062
00075000000750000007500000075000000000001100001101100110000000000760067000660600000660000060660020606062222222200000000022222220
00060000000600000006000000060000000000001100001101100110000000000070070000070700000770000070700022222220000000000000000000000000
0007033000700000007d330003330333000000000022220000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d3300000d33000028833003bb3bb3000000000888882000000000000000000000000000000000000000000000000000000000000000000000000000000000
0778827000288330071ffd1000884200002882000888882000288200000000000000000000000000000000000000000000000000000000000000000000000000
071ffd10077ffd700778827008ee8e800333e33308ee8e80088ee883000000000000000000000000000000000000000000000000000000000000000000000000
00288200071882100028820008ee8e8003bb4bb308ee8e8008eeee83000000000000000000000000000000000000000000000000000000000000000000000000
07d882d00028820007d882d00888882008eeee800088420008eeee80000000000000000000000000000000000000000000000000000000000000000000000000
0028820007d882d000dffd0008888820088ee88003bb3bb3088ee880000000000000000000000000000000000000000000000000000000000000000000000000
00dffd0000dffd000000000000222200002882000333033300288200000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000149aa94100000000012222100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00019777aa921000000029aaaa920000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d09a77a949920d00d0497777aa920d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0619aaa9422441600619a77944294160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07149a922249417006149a9442244160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07d249aaa9942d7006d249aa99442d60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
067d22444422d760077d22244222d770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d666224422666d00d776249942677d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
066d51499415d66001d1529749251d10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0041519749151400066151944a151660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a001944a100a0000400149a4100400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000049a400090000a0000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100003452032520305202e5202b520285202552022520205201b52018520165201352011520010200f5200c5200a5200852006520055200452003510015200052000000000000000000000000000100000000
000300002b650366402d65025650206301d6201762015620116200f6100d6100a6100761005610046100361002610026000160000600006000060000600006000000000000000000000000000000000000000000
00010000377500865032550206300d620085200862007620056100465004610026000260001600006200070000700006300060001600016200160001600016200070000700007000070000700007000070000700
000100000961025620006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
00060000010501605019050160501905001050160501905016050190601b0611b0611b061290001d000170002600001050160501905016050190500105016050190501b0611b0611b0501b0501b0401b0301b025
00060000205401d540205401d540205401d540205401d54022540225502255022550225500000000000000000000025534225302553022530255301d530255302253019531275322753027530275322753027530
000600001972020720227201b730207301973020740227401b74020740227402274022740000000000000000000001672020720257201b730257301973025740227401b740277402274027740277402774027740
011000001f5501f5501b5501d5501d550205501f5501f5501b5501a5501b5501d5501f5501f5501b5501d5501d550205501f5501b5501a5501b5501d5501f5502755027550255502355023550225502055020550
011000000f5500f5500a5500f5501b530165501b5501b550165500f5500f5500a5500f5500f5500a550055500a5500e5500f5500f550165501b5501b550165501755017550125500f5500f550125501055010550
011000001e5501c5501c550175501e5501b550205501d550225501e55023550205501c55026550265500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0110000017550145501455010550175500b550195500d5501b5500f5501c550105500455016550165500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090d00001b0001b0001b0001b0301b0001b0201d0201e030200302004020040200001e0002000020000200001b7001d7001b7001b7001b7001d700227001a7001b7001b700167001b7001b7001b7001c7001c700
050d00001f5001f0001f5001f5301f0001f5202152022530245302453024530245002250024500245002450000000000000000000000000000000000000000000000000000000000000000000000000000000000
010d00002200022000220002203022000220302403025030270302703027030270002500027000270002700000000000000000000000000000000000000000000000000000000000000000000000000000000000
4d1000002b0202b0202b0202b0202b0202b0202b0202b0202b020290202b0202c0202b0202b0202b0202602026020260202702027020270202b0202b0202b0202a0302a0302a0302703027030270302003020030
4d1000002003028030280302c0302a0302a0302a0302703027030270302c0302a030290302e0302e0300000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f00001e050000001e0501d0501b0501a0601a0621a062000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
050f00001b540070001b5401a54018540175501755217562075000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000
010c0000290502c0002a00029055290552a000270502900024000290002705024000240002400027050240002a05024000240002a0552a055240002905024000240002400029050240002a000290002405026200
510c00001431519315203251432519315203151432519325203151431519325203251431519315203251432519315203151432519325203151431519325203251431519315203251432519315203151432518325
010c00000175001750017500175001750017500175001750017500175001750017500175001750017500175001750017500175001750017500175001750017500175001750017500175001750017500175001750
010c0000195502c5002a50019555195552a500185502950024500295001855024500245002450018550245001b55024500245001b5551b555245001955024500245002450019550245002a500295001855026500
010c0000290502c0002a00029055290552a000270502900024000290002000024000240352504527050240002a050240002f0052d0552c0552400029050240002400024000240002400024030250422905026200
010c0000195502c5002a50019555195552a500185502950024500295002050024500145351654518550245001b550245002f5051e5551d5552450019550245002450024500245002450014530165401955026500
010c00002c05024000240002a05529055240002e050240002400029000270502400024000240002e050240003005024000240002e0552d05524000300502400024000290002905024000270002a0002900028000
510c0000143151931520325143251931520315163251932516315183151932516325183151931516325183251b3151e315183251b3251e315183151b3251e325183151b3151d325183251b3151d315183251b325
010c00000175001750017500175001750017500175001750037500375003750037500375003750037500375006750067500675006750067500675006750067500575005750057500575005750057500575005750
010c00001d55024500245001b55519555245001e550245002450029500165502450024500245001e550245001e55024500245001d5551b555245001d5502450024500295001855024500275002a5002950028500
11050000385623555233552315522f5522d5522b5522954227552265522355222552215521e5421d5421a5421854217542155421454212542105420e5420d5320b53209522075120551203512015120051200512
48020000173520f302113420932208322073200735000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400
080c000013056170661c06620066220362905631036320063600632006270061f0061900617000120002a00027000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0000070560c0660f07616076180661f056220472703733037330573c0673e0062b00625006200061b0061700614006110060f0060d0060c0060a006090060600606006050060500600000000000000000000
000400000744007420074200a40000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400
4a0200002c6412f66130661316613766132661326612b6612866125671226611e661146611a651166510864111641056410c64105641046410264102631026310163101621006210062100611006110061100611
010100000914008150081600f160121400f1400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020400003b6702b6403b67021620376702867031670266502c6502a650276502565022650206501d6501b6501965017640166401464012640106400d6400c6300a63008620076200562004620026200162000620
010a00000c4200c4200c4200c4200c4200c4200c4200c4200f4200f4200f4200f4200f4200f4200f4200f42010420104201042010420104201042010420104201442014420144201442014420144201442014420
010a00000532105320053200532005320053200532005320083200832008320083200832008320083200832009320093200932009320093200932009320093200d3200d3200d3200d3200d3200d3200d3200d320
000a002034615296152b6161e6061c6401d6452b6152760528615296152b6151e6001c6401d6452b6152761534615296152b6161e6061c6401d6452b6152760528615356152b6151e6051c6401d6452b61527615
050a00200232002320023200232002320023200232002320023200230502325023250232002325023200232503320033200332003320033200332003320033200732007320073200732007320073200732007320
010a000002320023200232002320023200232002320023200a3200a3200a3200a3200a3200a3200a3200a32005320053200532005320053200532005320053200332003320033200332003320033200332003320
010a000009220092200922009220092200922009220092200e2200e2200e2200e2200e2200e2200e2200e2200a2200a2200a2200a2200a2200a2200a2200a2200022000220002200022001220012200122001220
010a000005220052200522005220052200522005220052200e2200e2200e2200e2200e2200e2200e2200e2200a2200a2200a2200a2200a2200a2200a2200a2200022000220002200022001220012200122001220
010a00000d2200d2200d2200d2200d2200d2200d2200d220052200522005220052200522005220052200522011220112201122011220112201122011220112200322003220032200322003220032200322003220
150a00001522015220152201522015220152201522015220152201522015220152201322013220152201522016220162201622016220162201622016220162201922019220192201922019220192201922019220
150a00001a2201a2201a2201a2201a2201a2201a2251a2251d2201d2201d2201d2201d2201d2201d2201d22019220192201922019220192201922019220192201622016220162201622016220162201622016220
150a0000192201922019220192201922019220192251922511220112201122011220112201122011220112201d2201d2201d2201d2201d2201d2201d2201d22018220192211a2211d22121221252212622126221
090a00001d2171a217212172221729217262172d2172e2171d2171a2172121722217112170e21715217162171d2171a217212172221729217262172d2172e2171d2171a2172121722217112170e2171521716217
090a000029217262172d2172e2173521732217392173a21729217262172d2172e2171d2171a2172121722217112170e21715217162171d2171a2172121722217112170e21715217162170521702217092170a217
010a00000e003296000e0031e600286151d6052b605276150e003296052b6151e600286151d6452b615276051f6501f6301f6201e6001f6251f6251f625276050e003356052b6051e605106111c6112862133631
5c030000131212513131151381711b1613b1513b1413c14116141291413913135131321312d13228132221321c13216132131321d1320e1320d1320a132091320813206122051220412203122031220312201120
5c0400000817120161181610f17108171171711017109171071710d1610f161091510715106151051410514105132041320313202132021320113201132001320113201132011320112200122001220012200122
__music__
04 04050644
00 07084749
04 090a484a
04 0b0c0d44
00 0e084344
04 0f0a4344
04 10114e44
01 12131415
00 16131417
02 18191a1b
00 24256844
01 26272844
00 26282966
00 26272a65
00 262a2b65
00 26272c44
00 26292d44
00 26272c44
00 262a2e44
00 28292f44
00 28293044
00 272b2f44
02 25243144
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888eeeeee888888888888888888888888888888888888888888888888888888888888888888888888ff8ff8888228822888222822888888822888888228888
8888ee888ee88888888888888888888888888888888888888888888888888888888888888888888888ff888ff888222222888222822888882282888888222888
888eee8e8ee88888e88888888888888888888888888888888888888888888888888888888888888888ff888ff888282282888222888888228882888888288888
888eee8e8ee8888eee8888888888888888888888888888888888888888888888888888888888888888ff888ff888222222888888222888228882888822288888
888eee8e8ee88888e88888888888888888888888888888888888888888888888888888888888888888ff888ff888822228888228222888882282888222288888
888eee888ee888888888888888888888888888888888888888888888888888888888888888888888888ff8ff8888828828888228222888888822888222888888
888eeeeeeee888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111ddd1d1d1dd111dd111111dd1dd111dd1ddd111111dd1dd1111111dd1ddd1ddd1ddd1ddd1d1d1ddd111111111111111111111111111111111111
1111111111111d1d1d1d1d1d1d1111111d1d1d1d1d111d1111111d1d1d1d11111d1111d11d1d1d1d11d11d1d1d1d111111111111111111111111111111111111
1ddd1ddd11111dd11d1d1d1d1ddd11111d1d1d1d1d111dd111111d1d1d1d11111ddd11d11ddd1dd111d11d1d1ddd111111111111111111111111111111111111
1111111111111d1d1d1d1d1d111d11111d1d1d1d1d111d1111111d1d1d1d1111111d11d11d1d1d1d11d11d1d1d11111111111111111111111111111111111111
1111111111111d1d11dd1d1d1dd111111dd11d1d11dd1ddd11111dd11d1d11111dd111d11d1d1d1d11d111dd1d11111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111111111666166116661666117111711111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116661666161616661161117111711111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111bb1b1111bb1171117111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b111b111711111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b111bbb1711111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b11111b1711111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111bb1bbb1bb11171117111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111116616161666166616161111111111111c111c1c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111161116161161161616161111177711111c111c1c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111166616661161166611611111111111111ccc1ccc111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111616161161161116161111177711111c1c111c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111166116161666161116161111111111111ccc111c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111116616161666166616161111111111111c111c1c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111161116161161161616161111177711111c111c1c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111166616661161166616661111111111111ccc1ccc111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111616161161161111161111177711111c1c111c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111166116161666161116661111111111111ccc111c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111177111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111aaaaaaaaaaaaaaaaa11177711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111a666aa66aa66a6a6a111777711111cc11ccc1ccc111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111a6a6a6a6a6aaa6a6a1117711111111c1111c1c1c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111a666a6a6a666aa6aa1111171111111c11ccc1c1c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111a6aaa6a6aaa6a6a6a1111777111111c11c111c1c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111a6aaa66aa66aa6a6a111111111111ccc1ccc1ccc111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111116661166116616161111111111111cc11ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111161616161611161611111777111111c11c1c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111166616161666166611111111111111c11c1c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111161116161116111611111777111111c11c1c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111116111661166116661111111111111ccc1ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111dd1ddd1d111d111ddd1dd111111d1d1d1d1ddd1dd111111ddd11111dd11ddd1d1d11111ddd1ddd1ddd1ddd1ddd11111ddd11dd111111111111
1111111111111d111d1d1d111d111d111d1d11111d1d1d1d1d111d1d11111d1d11111d1d1d111d1d11111d111d1d1d1d1ddd1d11111111d11d11111111111111
1ddd1ddd11111d111ddd1d111d111dd11d1d11111d1d1ddd1dd11d1d11111ddd11111d1d1dd11d1d11111dd11dd11ddd1d1d1dd1111111d11ddd111111111111
1111111111111d111d1d1d111d111d111d1d11111ddd1d1d1d111d1d11111d1d11111d1d1d111ddd11111d111d1d1d1d1d1d1d11111111d1111d111111111111
11111111111111dd1d1d1ddd1ddd1ddd1ddd11111ddd1d1d1ddd1d1d11111d1d11111d1d1ddd1ddd11111d111d1d1d1d1d1d1ddd11111ddd1dd1111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111dd11ddd1ddd1d1d1dd111111ddd11dd11111ddd1d1d1ddd111111dd11dd1ddd1ddd1ddd1dd1111111d11ddd1ddd1ddd1ddd11dd11d111111111
1111111111111d1d1d1d1d1d1d1d1d1d111111d11d1d111111d11d1d1d1111111d111d111d1d1d111d111d1d11111d11111d1d1d1d111d1d1d11111d11111111
1ddd1ddd11111d1d1dd11ddd1d1d1d1d111111d11d1d111111d11ddd1dd111111ddd1d111dd11dd11dd11d1d11111d1111dd1d1d1dd11ddd1ddd111d11111111
1111111111111d1d1d1d1d1d1ddd1d1d111111d11d1d111111d11d1d1d111111111d1d111d1d1d111d111d1d11111d11111d1d1d1d111d11111d111d11111111
1111111111111ddd1d1d1d1d1ddd1d1d111111d11dd1111111d11d1d1ddd11111dd111dd1d1d1ddd1ddd1d1d111111d11ddd1ddd1d111d111dd111d111d11111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111111111661166616661616117111711111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111616161616161616171111171111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111111111616166116661616171111171111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111616161616161666171111171111111111111111111111111111111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116661666161616161666117111711111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111bb1b1111bb11711ccc11711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b111b1117111c1c11171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b111bbb17111c1c11171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b11111b17111c1c11171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111bb1bbb1bb111711ccc11711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111bbb1bbb1bbb1bb11bbb11711666116611661616111116661166116616161111166611661166161611111cc11ccc11711111111111111111111111111111
11111b1b1b1b11b11b1b11b1171116161616161116161111161616161611161611111616161616111616111111c11c1c11171111111111111111111111111111
11111bbb1bb111b11b1b11b1171116661616166611611111166616161666116111111666161616661666111111c11c1c11171111111111111111111111111111
11111b111b1b11b11b1b11b1171116111616111616161171161116161116161611711611161611161116117111c11c1c11171111111111111111111111111111
11111b111b1b1bbb1b1b11b111711611166116611616171116111661166116161711161116611661166617111ccc1ccc11711111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111bb1bbb1bbb11bb11711c111c1c11111c111c1c111116661166116611711111111111111111111111111111111111111111111111111111111111111111
11111b1111b11b1b1b1117111c111c1c11111c111c1c111116161616161111171111111111111111111111111111111111111111111111111111111111111111
11111b1111b11bb11b1117111ccc1ccc11111ccc1ccc111116661616166611171111111111111111111111111111111111111111111111111111111111111111
11111b1111b11b1b1b1117111c1c111c11711c1c111c117116111616111611171111111111111111111111111111111111111111111111111111111111111111
111111bb1bbb1b1b11bb11711ccc111c17111ccc111c171116111661166111711111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111bb1bbb1bbb11711cc111111111116616161666166616161111111111661616166616661616117111111111111111111111111111111111111111111111
11111b111b1b1b1b171111c111111111161116161161161616161111111116111616116116161616111711111111111111111111111111111111111111111111
11111bbb1bbb1bb1171111c111111111166616661161166611611111111116661666116116661666111711111111111111111111111111111111111111111111
1111111b1b111b1b171111c111711111111616161161161116161171111111161616116116111116111711111111111111111111111111111111111111111111
11111bb11b111b1b11711ccc17111111166116161666161116161711111116611616166616111666117111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822288828222822888888888888888888888888888888888888888888888888888888228888882228822828282228228882288866688
82888828828282888888888288288882882888888888888888888888888888888888888888888888888888888828888888288282828282888282828888888888
82888828828282288888888288288822882888888888888888888888888888888888888888888888888888888828888888288282822882288282822288822288
82888828828282888888888288288882882888888888888888888888888888888888888888888888888888888828888888288282828282888282888288888888
82228222828282228888888282888222822288888888888888888888888888888888888888888888888888888222888888288228828282228282822888822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
__meta:title__
Utility functions for the game.
