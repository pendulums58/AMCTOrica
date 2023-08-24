--수렵 길드
local s,id=GetID()
function s.initial_effect(c)
    --발동
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	--표적 특소시 카운터 / 서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.accon)
	e2:SetOperation(s.acop)
	c:RegisterEffect(e2)
	--레벨 / 랭크 8 이상 필드 벗어날때 카운터
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.accon2)
	e3:SetOperation(s.acop2)
	c:RegisterEffect(e3)
	--카운터 소모
end
function s.acfilter(c,tp)
	local lv=c:GetLevel()
	if c:IsType(TYPE_XYZ) then lv=c:GetRank() end
	return c:IsControler()==1-tp and lv>=8
end
function s.accon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.acfilter,1,nil,tp) and 
end
function s.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(SETCARD_HUNTER) and c:IsType(TYPE_MONSTER)
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(COUNTER_HUNT,1,true)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(g,1-tp)
	end
end

function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT) and c:IsControler()==1-tp and lv>=8
end
function s.accon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.acop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(COUNTER_HUNT,1,true)
end



function s.efilter(e,te)
	local lv=c:GetLevel()
	if c:IsType(TYPE_XYZ) then lv=c:GetRank() end
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER) and lv>=8
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(s.spchk,tp,0,LOCATION_MZONE,1,nil)
end
function s.spchk(c)
    local lv=c:GetLevel()
    if c:IsType(TYPE_XYZ) then lv=c:GetRank() end
    return lv>=8
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 
        and Duel.IsPlayerCanSpecialSummonMonster(tp,101275999,0xf,0x4011,0,0,8,RACE_DRAGON,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
        local token=Duel.CreateToken(tp,101275999)
        Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e1:SetValue(1)
        token:RegisterEffect(e1)
        Duel.SpecialSummonComplete()
    end
end