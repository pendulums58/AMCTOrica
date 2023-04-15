--에고파인더-포지티브 엠퍼시
function c101217020.initial_effect(c)
	--1번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,101217020)
	e2:SetTarget(c101217020.adtg2)
	e2:SetOperation(c101217020.activate)
	c:RegisterEffect(e2)
end
function c101217020.filter(c,tp)
	return c:IsSetCard(0xef7) and c:IsType(TYPE_MONSTER)
end
function c101217020.filter2(c,atk)
	return c:IsType(TYPE_MONSTER) and c:GetAttack()<atk
end
function c101217020.adtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return c101217020.filter2(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101217020.filter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101217020.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local dg=Duel.GetMatchingGroup(c101217020.filter2,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	if dg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE)
	end
end
function c101217020.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local dg=Duel.GetMatchingGroup(c101217020.filter2,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	if dg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=dg:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end