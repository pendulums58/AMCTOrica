--현환성창 스노우화이트
function c103551002.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103551002,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,103551002)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c103551002.thcon)
	e1:SetTarget(c103551002.thtg)
	e1:SetOperation(c103551002.thop)
	c:RegisterEffect(e1)
	--장착 조건 무시
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_EQUIP_IGNORE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetValue(1)
	e2:SetRange(0xff)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e2)	
	--파괴 대체
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c103551002.reptg)
	e3:SetValue(c103551002.repval)
	e3:SetOperation(c103551002.repop)
	c:RegisterEffect(e3)
end
function c103551002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c103551002.chk,1,nil) and ep==tp
end
function c103551002.chk(c)
	return c:IsSummonType(SUMMON_TYPE_PAIRING) and c:IsSetCard(0x64b)
end
function c103551002.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c103551002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
end
function c103551002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c103551002.thfilter,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c103551002.repfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsLocation(LOCATION_SZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c103551002.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c103551002.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c103551002.repval(e,c)
	return c103551002.repfilter(c,e:GetHandlerPlayer())
end
function c103551002.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
