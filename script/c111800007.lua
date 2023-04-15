--D_A_빈토레즈
local s,id=GetID()
function s.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsCode,CARD_TIMEMAKERS_VOID)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--소재 충전
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+100)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(s.ovtg)
	e3:SetOperation(s.ovop)
	c:RegisterEffect(e3)
end
s.listed_names={CARD_TIMEMAKERS_VOID}
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.chk,tp,LOCATION_SZONE,0,1,nil)
end
function s.chk(c)
	return c:IsSetCard(SETCARD_DA) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsFaceup() and s.ovfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.ovfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local tc=Duel.SelectTarget(tp,s.ovfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,s.ovchk,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function s.ovfilter(c,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(SETCARD_DA) 
		and Duel.IsExistingMatchingCard(s.ovchk,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c)
end
function s.ovchk(c,xc)
	return c:IsSetCard(SETCARD_DA)
end