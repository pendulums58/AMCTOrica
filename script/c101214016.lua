--스카이워커 서모스피어
function c101214016.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,c101214016.synfilter,aux.NonTuner(c101214016.synfilter1),1)
	c:EnableReviveLimit()
	--싱크로시 제외 효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112400516,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c101214016.condition)
	e1:SetTarget(c101214016.target)
	e1:SetOperation(c101214016.operation)
	c:RegisterEffect(e1)
	--레벨상승
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112400516,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetTarget(c101214016.thtg)
	e2:SetOperation(c101214016.thop)
	c:RegisterEffect(e2)	
end
function c101214016.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c101214016.filter(c,tp,lv)
	local tl=c:GetLevel()
	if c:IsType(TYPE_XYZ) then tl=c:GetRank() end
	if c:IsType(TYPE_LINK) then tl=c:GetLink() end
	return tl<lv and c:IsFaceup() 
end
function c101214016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lv=e:GetHandler():GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101214016.filter(chkc,lv) end
	if chk==0 then return Duel.IsExistingTarget(c101214016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101214016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,lv)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101214016.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,POS_FACEUP,REASON_EFFECT)~=0 and re and re:GetHandler():IsSetCard(0x9ec7) then
			local dam=tc:GetAttack()
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
function c101214016.synfilter(c)
	return c:IsSetCard(0xef5)
end
function c101214016.synfilter1(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c101214016.filter1(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c101214016.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101214016.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101214016.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101214016.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101214016.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if Duel.SelectOption(tp,aux.Stringid(112400516,1),aux.Stringid(112400516,2))==0 then
			e1:SetValue(1)
		else e1:SetValue(2) end
		tc:RegisterEffect(e1)
	end
end