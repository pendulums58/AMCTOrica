--극 여환무장【미카즈키】
function c101234006.initial_effect(c)
	--융합 소재
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,101234004,101234005,1,true,true)
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c101234006.val)
	c:RegisterEffect(e1)
	--2번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c101234006.descon)
	e2:SetTarget(c101234006.destg)
	e2:SetOperation(c101234006.desop)
	c:RegisterEffect(e2)
	--3번 효과
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c101234006.thcon2)
	e3:SetTarget(c101234006.thtg2)
	e3:SetOperation(c101234006.thop2)
	c:RegisterEffect(e3)
end
function c101234006.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER)
end
function c101234006.val(e,te)
    return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c101234006.descon(e)
	local ec=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker()==ec or Duel.GetAttackTarget()==ec
end
function c101234006.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=Duel.GetAttacker()
	if tc==ec then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_Remove,tc,1,0,0)
end
function c101234006.desop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=Duel.GetAttacker()
	if tc==ec then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
	if ec:IsChainAttackable() then
		Duel.ChainAttack()
	end
end
function c101234006.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:GetPreviousControler()==tp
		and c:GetPreviousTypeOnField()==TYPE_EQUIP+TYPE_SPELL
end
function c101234006.eqfilter(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER)
end
function c101234006.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c101234006.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct1,ct2=0
	if Duel.IsExistingTarget(c101234006.filter2,tp,LOCATION_MZONE,0,1,nil) then ct1=1 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then ct2=1 end
	if chk==0 then return Duel.IsExistingMatchingCard(c101234006.eqfilter,tp,LOCATION_HAND,0,1,nil) and (ct1==1 or ct2==1) end
	if ct1==1 and ct2==1 then
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end
	if ct1==1 and ct2~=1 then Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND) end
	if ct2==1 and ct1~=1 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0) end
end
function c101234006.thop2(e,tp,eg,ep,ev,re,r,rp)
	local ct1,ct2=0
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then ct1=1 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then ct2=1 end
	if ct1==0 and ct2==0 then return end
	local g=Duel.SelectMatchingCard(tp,c101234006.eqfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g1=g:GetFirst()
	if g1 then
		local sel=0
		if ct2==1 then sel=1 end
		if ct1==1 and ct2==1 then
			sel=Duel.SelectOption(tp,aux.Stringid(101234006,0),aux.Stringid(101234006,1))
		end      
		if sel==0 then
			if g1 and Duel.IsExistingTarget(c101234006.filter2,tp,LOCATION_MZONE,0,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				t=Duel.SelectMatchingCard(tp,c101234006.filter2,tp,LOCATION_MZONE,0,1,1,nil)
				local tc=t:GetFirst()
				if Duel.Equip(tp,g1,tc) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_EQUIP_LIMIT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(c101234006.eqlimit)
					e1:SetLabelObject(tc)
					g1:RegisterEffect(e1)
				end
			end      
		end
		if sel==1 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101234006.eqlimit(e,c)
	return c==e:GetLabelObject()
end