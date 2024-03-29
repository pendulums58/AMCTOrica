

--카드 스크립팅의 간략화를 위한 유틸리티 모음
--주석으로 적힌 대로 사용합니다.

-------- 목차 --------
-- JustDraw (단순 드로우)
-- JustSearch (단순 서치)
-- JustDump (단순 덤핑)
-- Delete (소멸)
-- SelfCost 계통 (자기 자신을 코스트로 XX하고 발동한다.)
-- OvCost (엑시즈 소재를 X개 제거하고 발동)
-- htX 계통 (패를 코스트로 XX하고 발동한다.)
-- GetBaseType (카드의 종류 (몬스터 / 마법 / 함정) 관련 단순화)
-- SSCon 계통 (XX 소환 성공시 발동한다.)
-- Card.IsNot계통 (JustSearch 연계용, Card.Is의 부정형)
-- 축약자(constant 코드 축약)
---------------------


-- JustDraw (다른 효과 없이 "덱에서 X장 드로우한다." 효과만을 가진 경우. Condition 및 Cost 등과 동시 사용 가능.)
-------------예시 스크립트------------- ☆Ctrl + Q로 주석 추가 / 해제하여 확인 가능.
-- local e1=Effect.CreateEffect(c)
-- e1:SetCondition(대충 컨디션)
-- e1:SetCost(대충 코스트)
-- e1:SetType(EFFECT_TYPE_IGNITION)
-- e1:SetCountLimit(1)
-- e1:SetRange(LOCATION_MZONE)
-- cyan.JustDraw(e1,2)
-- c:RegisterEffect(e1)
-----------------------------------
-- △ 조건(컨디션) 만족 시, 코스트를 지불하는 기동 효과로 2장을 드로우한다.
-----------------------------------
function cyan.JustDraw(e,ct)
	e:SetTarget(cyan.JsDTarget(ct))
	e:SetOperation(cyan.JsDOperation(ct))
end
function cyan.JsDTarget(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(ct)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)	
	end
end
function cyan.JsDOperation(ct)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end


-- JustSearch (다른 효과 없이 "XX에서 XX를 패에 넣는다" 만을 가진 효과. 대상 지정 / 비대상 지정 선택 가능.)
-- 매개 변수는 (어디에서,필터,조건,필터,조건... 반복)
-- SetProperty(EFFECT_FLAG_CARD_TARGET)이 사용되는 경우, 자동으로 대상을 지정하여 패에 넣는 효과로 변화한다.
-------------예시 스크립트------------- ☆Ctrl + Q로 주석 추가 / 해제하여 확인 가능.
-- local e1=Effect.CreateEffect(c)
-- e1:SetCode(EVENT_SUMMON_SUCCESS)
-- e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
-- e1:SetCountLimit(1)
-- cyan.JustSearch(e1,LOCATION_DECK,Card.IsType,TYPE_MONSTER,Card.IsLevel,3,Card.IsAttribute,ATTRIBUTE_LIGHT)
-- c:RegisterEffect(e1)
-----------------------------------
-- △ 일반 소환 성공시, 덱에서 레벨 3 / 빛 속성 몬스터 1장을 패에 넣는다.
-----------------------------------
-------------예시 스크립트------------- ☆Ctrl + Q로 주석 추가 / 해제하여 확인 가능.
-- local e1=Effect.CreateEffect(c)
-- e1:SetCode(EVENT_SUMMON_SUCCESS)
-- e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
-- e1:SetCountLimit(1)
-- e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
-- cyan.JustSearch(e1,LOCATION_GRAVE,Card.IsType,TYPE_MONSTER,Card.IsLevel,3,Card.IsAttribute,ATTRIBUTE_LIGHT)
-- c:RegisterEffect(e1)
-----------------------------------
-- △ 일반 소환 성공시, 묘지의 레벨 3 / 빛 속성 몬스터 1장을 대상으로 하여 발동. 대상 카드를 패에 넣는다.
-----------------------------------

function cyan.JustSearch(e,loc,...)
	local par={...}
	e:SetTarget(cyan.JSTarget(loc,table.unpack(par)))
	e:SetOperation(cyan.JSOperation(loc,table.unpack(par)))
end
function cyan.JSTarget(loc,...)
	local par={...}
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then  
		local fc=par[1]
		local va=par[2]
		for i=1,#par do
			if type(par[i])=="function" then
				fc=par[i]
				va=par[i+1]
				if not fc(chkc,va) then return false end	
			end
		end
		return true
	end
		if chk==0 then 
			if e:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
				return Duel.IsExistingTarget(cyan.jsfilter,tp,loc,0,1,nil,table.unpack(par)) 
			else
				return Duel.IsExistingMatchingCard(cyan.jsfilter,tp,loc,0,1,nil,table.unpack(par)) 
			end
		
		end
		if e:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
			local g=Duel.SelectTarget(tp,cyan.jsfilter,tp,loc,0,1,1,nil,table.unpack(par))
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		else
			local cat=CATEGORY_TOHAND
			if loc==LOCATION_DECK then cat=cat+CATEGORY_SEARCH end
			Duel.SetOperationInfo(0,cat,nil,1,tp,loc)
		end
			
	end
end
function cyan.jsfilter(c,...)
	local par={...}
	local fc=par[1]
	local va=par[2]
	for i=1,#par do
		if type(par[i])=="function" then
			if type(par[i+1])=="number" then
				fc=par[i]
				va=par[i+1]
				if not fc(c,va) then return false end
			end	
		end
	end
	return c:IsAbleToHand()	
end
function cyan.JSOperation(loc,...)
	local par={...}
	return function(e,tp,eg,ep,ev,re,r,rp)
		if e:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cyan.jsfilter,tp,loc,0,1,1,nil,table.unpack(par))
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end		
		end

	end
end


-- JustDump (다른 효과 없이 "덱에서 묘지로 보낸다" 만을 가진 효과.)
-- 매개 변수는 (최소 매수, 최대 매수,필터,조건,필터,조건... 반복)
-------------예시 스크립트------------- ☆Ctrl + Q로 주석 추가 / 해제하여 확인 가능.
-- local e1=Effect.CreateEffect(c)
-- e1:SetCode(EVENT_SUMMON_SUCCESS)
-- e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
-- e1:SetCountLimit(1)
-- cyan.JustDump(e1,1,1,Card.IsType,TYPE_MONSTER,Card.IsLevel,3,Card.IsAttribute,ATTRIBUTE_LIGHT)
-- c:RegisterEffect(e1)
-----------------------------------
-- △ 일반 소환 성공시, 덱에서 레벨 3 / 빛 속성 몬스터 1장을 묘지로 보낸다.
-----------------------------------

function cyan.JustDump(e,min,max,...)
	local par={...}
	e:SetTarget(cyan.JDTarget(min,max,table.unpack(par)))
	e:SetOperation(cyan.JDOperation(min,max,table.unpack(par)))
end
function cyan.JDTarget(min,max,...)
	local par={...}
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then  
		local fc=par[1]
		local va=par[2]
		for i=1,#par do
			if type(par[i])=="function" then
				if type(par[i+1])=="number" then
					fc=par[i]
					va=par[i+1]
					if not fc(chkc,va) then return false end
				end	
			end
		end
		return true
	end
		if chk==0 then 
			return Duel.IsExistingMatchingCard(cyan.jdfilter,tp,LOCATION_DECK,0,min,nil,table.unpack(par)) 
		end
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,min,tp,LOCATION_DECK)
	end
end
function cyan.jdfilter(c,...)
	local par={...}
	local fc=par[1]
	local va=par[2]
	for i=1,#par do
		if type(par[i])=="function" then
			if type(par[i+1])=="number" then
				fc=par[i]
				va=par[i+1]
				if not fc(c,va) then return false end
			end	
		end
	end
	return c:IsAbleToGrave()
end
function cyan.JDOperation(min,max,...)
	local par={...}
	return function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(tp,cyan.jdfilter,tp,LOCATION_DECK,0,min,max,nil,table.unpack(par))
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end		
	end
end

-- Delete (해당 카드들을 소멸시킨다. 이미 소멸된 카드를 지정하여 상호작용하는 경우의 안정성을 보장할 수 없다.)
-- 매개 변수는(e,소멸시킬 카드 혹은 그룹)
-- 레거시 함수로 보존 중. Duel.Delete 대신 Duel.Exile을 사용하는 것을 권장.
-------------예시 스크립트------------- ☆Ctrl + Q로 주석 추가 / 해제하여 확인 가능.
-- if tc:IsRelateToEffect(e) then
-- 		Duel.Delete(e,tc)
-- end
-----------------------------------
-- △ tc가 대상 지정에서 벗어나지 않았다면, tc를 소멸시킨다.
-----------------------------------
function Duel.Delete(e,sg)	
	local over=Group.CreateGroup()
	if type(sg)=="Group" then
		local tc=sg:GetFirst()
			while tc do
				if tc:IsLocation(LOCATION_REMOVED) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(0x30)
					tc:RegisterEffect(e1)
				else
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_REMOVE_REDIRECT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(0x30)
					tc:RegisterEffect(e1)
				end
				local ov=tc:GetOverlayGroup()
				over:Merge(ov)
				if tc:GetAdmin() then
					over:AddCard(tc:GetAdmin())
				end
				tc=sg:GetNext()
			end
		local tg=sg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		sg:Sub(tg)
		Duel.SendtoGrave(over,REASON_RULE)
		Duel.SendtoGrave(tg,REASON_RULE)
		Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
	else
		local ov=sg:GetOverlayGroup()
		over:Merge(ov)
		if sg:GetAdmin() then
			over:AddCard(sg:GetAdmin())
		end
		Duel.SendtoGrave(over,REASON_RULE)
		if sg:IsLocation(LOCATION_REMOVED) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(0x30)
			sg:RegisterEffect(e1)
			Duel.SendtoGrave(sg,REASON_RULE)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_REDIRECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(0x30)
			sg:RegisterEffect(e1)
			Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
		end
	end
end

-- SelfCost 계통(자신을 버리고 / 릴리스하고 / 제외하고 / 묘지로 보내고 등등의 코스트를 간략화한다.)
-------------예시 스크립트------------- ☆Ctrl + Q로 주석 추가 / 해제하여 확인 가능.
-- e1:SetCost(cyan.selfrelcost)	◁ 자신을 릴리스하고 발동
-- e1:SetCost(cyan.selftgcost)	◁ 자신을 묘지로 보내고 발동
-- e1:SetCost(cyan.selfrmcost)	◁ 자신을 제외하고 발동
-- e1:SetCost(cyan.selftdcost)	◁ 자신을 덱으로 되돌리고 발동
-- e1:SetCost(cyan.selfdiscost)	◁ 자신을 패에서 버리고 발동
-- e1:SetCost(cyan.selfthcost)	◁ 자신을 패로 되돌리고 발동
-----------------------------------
function cyan.selfrelcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cyan.selftgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cyan.selfrmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cyan.selftdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cyan.selfdiscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cyan.selfthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end


-- ovcost 계통(엑시즈 소재를 X개 제거하고 발동 코스트를 간략화한다.)
-------------예시 스크립트------------- ☆Ctrl + Q로 주석 추가 / 해제하여 확인 가능.
-- e1:SetCost(cyan.ovcost(1))	◁ 엑시즈 소재를 1개 제거하고 발동
-----------------------------------

function cyan.ovcost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end
		e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
	end
end

-- htX 계통(패를 버리고 / 제외하고 / 묘지로 보내고 등등의 코스트를 간략화한다.)
-------------예시 스크립트------------- ☆Ctrl + Q로 주석 추가 / 해제하여 확인 가능.
-- e1:SetCost(cyan.dhcost(1))	◁ 패를 1장 버리고 발동
-- e1:SetCost(cyan.htgcost(1))	◁ 패를 1장 묘지로 보내고 발동
-- e1:SetCost(cyan.hrmcost(1))	◁ 패를 1장 제외하고 발동
-- e1:SetCost(cyan.htdcost(1))	◁ 패를 1장 덱으로 되돌리고 발동
-----------------------------------
function cyan.dhcost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,ct,nil) end
		Duel.DiscardHand(tp,Card.IsDiscardable,ct,ct,REASON_COST+REASON_DISCARD)
	end
end
function cyan.htgcost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,ct,nil) end
		Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,ct,ct,REASON_COST)
	end
end
function cyan.hrmcost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,ct,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,ct,ct,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function cyan.htdcost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(c:IsAbleToDeck(),tp,LOCATION_HAND,0,ct,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c:IsAbleToDeck(),tp,LOCATION_HAND,0,ct,ct,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	end
end


-- GetBaseType(카드의 종류를 참조하는 카드의 스크립트 간략화용)
-------------예시 스크립트------------- ☆Ctrl + Q로 주석 추가 / 해제하여 확인 가능.
-- local ty=tc:GetBaseType()
-----------------------------------
-- △ tc의 기본 타입(몬스터 / 마법 / 함정)을 반환한다.
-- 일부 함정 몬스터 등으로 몬스터 / 함정 양쪽 타입을 모두 가진 경우, 몬스터+함정을 동시에 반환한다.
-----------------------------------
function Card.GetBaseType(c)
	local ty=0
	if c:IsType(TYPE_MONSTER) then ty=ty+TYPE_MONSTER end
	if c:IsType(TYPE_SPELL) then ty=ty+TYPE_SPELL end
	if c:IsType(TYPE_TRAP) then ty=ty+TYPE_TRAP end
	return ty
end
function Card.GetExtraType(c)
	local ty=0
	if c:IsType(TYPE_FUSION) then ty=ty+TYPE_FUSION end
	if c:IsType(TYPE_SYNCHRO) then ty=ty+TYPE_SYNCHRO end
	if c:IsType(TYPE_XYZ) then ty=ty+TYPE_XYZ end
	if c:IsType(TYPE_ACCESS) then ty=ty+TYPE_ACCESS end
	if c:IsType(TYPE_LINK) then ty=ty+TYPE_LINK end
	if c:IsType(TYPE_PAIRING) then ty=ty+TYPE_PAIRING end
	return ty
end

-- SSCon 계통 (특정 소환법으로 소환에 성공한 경우에 발동하는 효과. SetCode(EVENT_SPSUMMON_SUCCESS)와 함께 사용해야 한다.)
-------------예시 스크립트------------- ☆Ctrl + Q로 주석 추가 / 해제하여 확인 가능.
-- local e1:SetCondition(cyan.FuSSCon) 	◁ 융합 소환 성공시 발동
-- local e1:SetCondition(cyan.RitSSCon)	◁ 의식 소환 성공시 발동
-- local e1:SetCondition(cyan.SynSSCon)	◁ 싱크로 소환 성공시 발동
-- local e1:SetCondition(cyan.XyzSSCon)	◁ 엑시즈 소환 성공시 발동
-- local e1:SetCondition(cyan.PenSSCon)	◁ 펜듈럼 소환 성공시 발동
-- local e1:SetCondition(cyan.LinkSSCon)◁ 링크 소환 성공시 발동
-- local e1:SetCondition(cyan.AccSSCon)	◁ 액세스 소환 성공시 발동
-- local e1:SetCondition(cyan.PairSSCon)◁ 페어링 소환 성공시 발동
-----------------------------------

function cyan.FuSSCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function cyan.RitSSCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function cyan.SynSSCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cyan.XyzSSCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end
function cyan.PenSSCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function cyan.LinkSSCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cyan.AccSSCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ACCESS)
end
function cyan.PairSSCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PAIRING)
end

-- Card.IsNot 계통(Card.Is 계통의 부정형으로, JustSearch와의 연계를 권장.)
-------------예시 스크립트------------- ☆Ctrl + Q로 주석 추가 / 해제하여 확인 가능.
-- c:IsNotCode(코드번호)	◁ 코드번호가 아닌 카드를 검색
-- c:IsNotRace()		◁ 해당 종족이 아닌 카드를 검색
-- c:IsNotAttribute()	◁ 해당 속성이 아닌 카드를 검색
-----------------------------------

function Card.IsNotCode(c,code)
	return not c:IsCode(code)
end
function Card.IsNotSetCard(c,code)
	return not c:IsSetCard(code)
end
function Card.IsNotRace(c,race)
	return not c:IsRace(race)
end
function Card.IsNotAttribute(c,att)
	return not c:IsAttribute(att)
end
function Card.IsNotHandler(c,e)
	return not c==e:GetHandler()
end
function Card.IsNotThisTurn(c,chk)
	local id=Duel.GetTurnCount()
	return not c:GetTurnID()==id
end


--기타 (대분류에 속하지 않는 기타 함수)

function cyan.oppofalse(e,rp,tp)
	return tp==rp
end

function Card.IsNormalSpell(c)
	return c:GetType()==TYPE_SPELL
end

function Card.IsNormalTrap(c)
	return c:GetType()==TYPE_TRAP
end

function Card.GetStar(c)
	local lv=c:GetLevel()
	if c:IsType(TYPE_XYZ) then lv=c:GetRank() end
	return lv
end
function Card.IsStarAbove(c,lv)
	if c:IsLevelAbove(lv) or c:IsRankAbove(lv) then return true end
	return false
end
function Card.IsStarBelow(c,lv)
	if c:IsLevelBelow(lv) or c:IsRankBelow(lv) then return true end
	return false
end
-- 축약자(constant 계통 코드의 축약. 편의성용)
-------------예시 스크립트------------- ☆Ctrl + Q로 주석 추가 / 해제하여 확인 가능.
-- e1:SetCode(EV_SPSC)	◁ 특수 소환 성공시(EVENT_SPSUMMON_SUCCESS)의 축약
-- 이와 같이, 하단의 각 코드는 오른쪽 코드의 축약.
-----------------------------------
EV_SPSC=EVENT_SPSUMMON_SUCCESS
EV_SUSC=EVENT_SUMMON_SUCCESS

--세미토큰 효과
function cyan.SemiTokenAttribute(c)
	--묘지로 보내진 경우 소멸
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e:SetCode(EVENT_TO_GRAVE)
	e:SetOperation(cyan.semigraveop)
	c:RegisterEffect(e)
	local e1=e:Clone()
	e1:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e1)
end
function cyan.semigraveop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Delete(e,e:GetHandler())
end


--레거시 자신 릴리스 코스트 함수
function cyan.relcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end




