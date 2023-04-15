--신살마도 아지사이
c111310091.AccessMonsterAttribute=true
function c111310091.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310091.afil1,c111310091.afil2)
	c:EnableReviveLimit()
	--공격력 변화
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310091,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c111310091.atkcon)
	e1:SetTarget(c111310091.atktg)
	e1:SetOperation(c111310091.atkop)
	c:RegisterEffect(e1)
	--패교환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111310091,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c111310091.spcon1)
	e2:SetTarget(c111310091.sptg)
	e2:SetOperation(c111310091.spop)
	c:RegisterEffect(e2)	
end
function c111310091.afil1(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c111310091.afil2(c)
	return c:IsType(TYPE_ACCESS)
end
function c111310091.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetAdmin():GetAttack()>0
end
function c111310091.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c111310091.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ad=e:GetHandler():GetAdmin()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and ad then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ad:GetAttack())
		tc:RegisterEffect(e1)
	end
end
function c111310091.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_ACCESS
end
function c111310091.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetChainLimit(c111310091.chainlm)
end
function c111310091.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c111310091.chainlm(e,rp,tp)
	return tp==rp
end
