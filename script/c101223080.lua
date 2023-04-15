--나선벼락 수채화
function c101223080.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_FIRE+ATTRIBUTE_LIGHT),1)
	c:EnableReviveLimit()
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101223080.tg)
	e1:SetOperation(c101223080.op)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	c:RegisterEffect(e1)
end
function c101223080.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFaceup() and chkc:GetDefense()<=1600 end
	if chk==0 then return true end
	if Duel.IsExistingTarget(Card.IsDefenseBelow,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,1600) 
		and Duel.SelectYesNo(tp,aux.Stringid(101223080,0)) then
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
		e:SetOperation(c101223080.desop)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsDefenseBelow,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,1600)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
	end
end
function c101223080.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Recover(tp,800,REASON_EFFECT)
	end
end
function c101223080.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,800,REASON_EFFECT)
	Duel.Recover(tp,800,REASON_EFFECT)
end