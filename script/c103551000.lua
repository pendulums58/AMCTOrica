--몽환성자 클락스미스
function c103551000.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1,103551000)
	e1:SetCode(EVENT_EQUIP)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c103551000.thcon)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsSetCard,0x64b)
	c:RegisterEffect(e1)
	--장착 조건 무시
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_EQUIP_IGNORE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetValue(1)
	e2:SetRange(0xff)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e2)
	--체인 불가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c103551000.actop)
	c:RegisterEffect(e3)
end
function c103551000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(Card.IsControler,1,nil,tp)
end
function c103551000.actop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_EQUIP) and re:IsActiveType(TYPE_SPELL) and ep==tp then
		Duel.SetChainLimit(c103551000.chainlm)
	end
end
function c103551000.chainlm(e,rp,tp)
	return tp==rp
end