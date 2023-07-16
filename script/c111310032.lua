--PM(프로토콜 마스터).64 화이트아웃 캡틴
c111310032.AccessMonsterAttribute=true
c111310032.ProtocolMasterNumber=100
function c111310032.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310032.afil1,c111310032.afil2)
	c:EnableReviveLimit()
	--2회 공격
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--무효
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111310032,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetTarget(c111310032.destg)
	e2:SetOperation(c111310032.desop)
	c:RegisterEffect(e2)
	--데미지
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111310032,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c111310032.damcon)
	e3:SetTarget(c111310032.damtg)
	e3:SetOperation(c111310032.damop)
	c:RegisterEffect(e3)
	--공격 불가
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(cyan.adcon)
	e4:SetTarget(c111310032.antarget)
	c:RegisterEffect(e4)
	--효과 발동 불가
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e5)
end
function c111310032.afil1(c)
	return c:GetLevel()>=1
end
function c111310032.afil2(c)
	return c:GetLevel()>=5
end
function c111310032.nfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c111310032.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c111310032.nfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c111310032.nfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c111310032.nfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c111310032.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c111310032.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0 or e:GetHandler():GetAttackedCount()>0
end
function c111310032.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad==nil then return true end
	if ad:GetAttack()==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ad:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ad:GetAttack())
end
function c111310032.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c111310032.antarget(e,c)
	return c~=e:GetHandler()
end
