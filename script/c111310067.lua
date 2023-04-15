--Cyan.lua
function c111310067.initial_effect(c)
	--덱으로 돌아가도록 하죠
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(0xff-LOCATION_DECK)
	e1:SetOperation(c111310067.tdop)
	c:RegisterEffect(e1)
	--덱에서 발동하는 충격적인 효과들
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_DECK)
	e2:SetOperation(c111310067.cyanop)
	c:RegisterEffect(e2)
end
function c111310067.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	Duel.SendtoDeck(c,nil,2,REASON_RULE)
end
function c111310067.cyanop(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(tp,aux.Stringid(111310067,0),aux.Stringid(111310067,1),aux.Stringid(111310067,2),aux.Stringid(111310067,3))
	if op==3 then
		op=3+Duel.SelectOption(tp,aux.Stringid(111310067,4),aux.Stringid(111310067,5),aux.Stringid(111310067,6),aux.Stringid(111310067,3))
		if op==6 then
			op=6+Duel.SelectOption(tp,aux.Stringid(111310067,7),aux.Stringid(111310067,8),aux.Stringid(111310067,9),aux.Stringid(111310067,3))
			if op==9 then
				op=9+Duel.SelectOption(tp,aux.Stringid(111310067,10),aux.Stringid(111310067,15))
			end
		end
	end
	if op==0 then
		--0번 - 스크립트 리로드
		c111310067.screload(e,tp,eg,ep,ev,re,r,rp)
	elseif op==1 then
		--1번 - 패로 되돌리기
		c111310067.tohand(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then
		--2번 - 드로우
		c111310067.draw(e,tp,eg,ep,ev,re,r,rp)
	elseif op==3 then
		--3번 - 카드 창조
		c111310067.create(e,tp,eg,ep,ev,re,r,rp)
	elseif op==4 then
		--4번 - 카드 파괴
		c111310067.destroy(e,tp,eg,ep,ev,re,r,rp)
	elseif op==5 then
		--5번 - 카드 제외
		c111310067.remove(e,tp,eg,ep,ev,re,r,rp)
	elseif op==6 then
		--6번 - 카드 서치
		c111310067.search(e,tp,eg,ep,ev,re,r,rp)
	elseif op==7 then
		--7번 - cyan.lua 리로드
		c111310067.reloadcyan(e,tp,eg,ep,ev,re,r,rp)
	elseif op==8 then
		--8번 - LP 증감
		c111310067.lpchange(e,tp,eg,ep,ev,re,r,rp)
	elseif op==9 then
		--9번 - 일소 / 특소 취급
		c111310067.sumtrigger(e,tp,eg,ep,ev,re,r,rp)
	elseif op==10 then
		
	elseif op==11 then
	
	elseif op==12 then
	
	end
end
function c111310067.screload(e,tp,eg,ep,ev,re,r,rp)
	--스크립트 리로드
	--원하는 만큼 카드를 골라, 스크립트를 다시 로드한다.
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,99,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local code=tc:GetOriginalCode()
			local mt=_G["c"..code]
			if code>=100000000 then
				Duel.LoadScript("c"..code..".lua")
				Duel.LoadScript("c"..code..".lua")
				local ct=0
				if mt.eff_ct[tc][ct]==nil then
					Debug.Message(tc:GetCode().."번 코드의 카드는 효과가 없습니다. 로드하지 않습니다.")
				end
				while mt.eff_ct[tc][ct] do
					local e=mt.eff_ct[tc][ct]
					e:SetCondition(c111310067.deleffcon)
					ct=ct+1
				end
				tc:SetStatus(STATUS_INITIALIZING,true)
				mt.initial_effect(tc)
				tc:SetStatus(0,true)
			else
				Debug.Message("1억번 미만의 코드는 재로드하지 않습니다. 코드 = "..code)
			end
			tc=g:GetNext()
		end
		Debug.Message(g:GetCount().."장의 카드가 리로드되었습니다.")
	end
end
function c111310067.deleffcon(e,tp,eg,ep,ev,re,r,rp)
	return false
end
function c111310067.tohand(e,tp,eg,ep,ev,re,r,rp)
	--패로 돌리기
	--카드를 원하는만큼 패로 돌린다
	local loc=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,loc,loc,1,99,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_RULE)
	end
end
function c111310067.draw(e,tp,eg,ep,ev,re,r,rp)
	--드로우
	--원하는 만큼 드로우
	local t={}
	local i=1
	for i=1,10 do t[i]=i end
	local a1=Duel.AnnounceNumber(tp,table.unpack(t))
	if Duel.SelectOption(tp,102,103)==0 then
		Duel.Draw(tp,a1,REASON_EFFECT)
	else
		Duel.Draw(1-tp,a1,REASON_EFFECT)
	end
end
function c111310067.create(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.AnnounceCard(tp)
	local p=tp
	if Duel.SelectOption(tp,102,103)==1 then p=1-tp end
	local token=Duel.CreateToken(p,ac)
	local op=Duel.SelectOption(tp,1001,1008)
	if op==1 then
		local loc=LOCATION_SZONE
		if token:IsType(TYPE_MONSTER) then loc=LOCATION_MZONE end
		Duel.MoveToField(token,tp,p,loc,POS_FACEUP_ATTACK,true)			
	else
		Duel.SendtoHand(token,nil,REASON_EFFECT)
	end
	Duel.SetTargetCard(token)
end
function c111310067.destroy(e,tp,eg,ep,ev,re,r,rp)
	--파괴
	--카드를 원하는만큼 파괴한다
	local loc=LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,loc,loc,1,99,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c111310067.remove(e,tp,eg,ep,ev,re,r,rp)
	--제외
	--카드를 원하는만큼 제외한다
	local loc=LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,loc,loc,1,99,nil)
	if g:GetCount()>0 then
		local pos=POS_FACEUP
		if Duel.SelectOption(tp,60,61)==1 then pos=POS_FACEDOWN end
		Duel.Remove(g,pos,REASON_EFFECT)
	end
end
function c111310067.search(e,tp,eg,ep,ev,re,r,rp)
	--서치
	--카드를 원하는만큼 서치한다
	local loc=LOCATION_DECK
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,loc,0,1,99,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c111310067.reloadcyan(e,tp,eg,ep,ev,re,r,rp)
	pcall(dofile,"expansions/script/init.lua")
end
function c111310067.lpchange(e,tp,eg,ep,ev,re,r,rp)
	local p=tp
	if Duel.SelectOption(tp,102,103)==1 then p=1-tp end
	local t={}
	local l=0
	while l<8 do
		t[l]=l*1000
		l=l+1
	end
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))	
	local lp=announce
	local t1={}
	local l1=0
	while l1<11 do
		t1[l1]=l1*100
		l1=l1+1
	end
	local announce1=Duel.AnnounceNumber(tp,table.unpack(t1))	
	lp=lp+announce1
	if Duel.SelectOption(tp,1122,1123)==0 then
		Duel.Damage(p,lp,REASON_EFFECT)
	else
		Duel.Recover(p,lp,REASON_EFFECT)
	end
end
function c111310067.sumtrigger(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,99,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.RaiseSingleEvent(tc,EVENT_SPSUMMON_SUCCESS,e,REASON_EFFECT,tp,tp,1)
		tc=g:GetNext()
	end
	Duel.RaiseEvent(g,EVENT_SPSUMMON_SUCCESS,e,REASON_EFFECT,tp,tp,1)
end