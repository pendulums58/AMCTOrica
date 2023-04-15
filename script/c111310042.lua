--각록의 관리자
c111310042.AccessMonsterAttribute=true
function c111310042.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310042.afilter1,c111310042.afilter2)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310042.con)
	e1:SetOperation(c111310042.thop1)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(c111310042.rcon)
	c:RegisterEffect(e2)
	--수비 표시로 변경
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111310042,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c111310042.target)
	e3:SetOperation(c111310042.operation)
	c:RegisterEffect(e3)
	--효과를 무효로
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(111310042,1))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c111310042.rcon)
	e4:SetTarget(c111310042.target1)
	e4:SetOperation(c111310042.operation1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--어드민 제거
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetDescription(aux.Stringid(111310042,2))
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c111310042.rmcon)
	e6:SetCost(c111310042.cost)
	e6:SetOperation(c111310042.rmop)
	c:RegisterEffect(e6)	
end
function c111310042.afilter1(c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function c111310042.afilter2(c)
	return not c:IsRace(RACE_AQUA)
end
function c111310042.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c111310042.thop1(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 메마른 초목의 관리자가 감지되었습니다.")
end
function c111310042.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanChangePosition() and c:GetSummonPlayer()==1-tp and (not e or c:IsRelateToEffect(e))
end
function c111310042.rcon(e)
	local c=e:GetHandler()
	return c:GetAdmin()==nil
end
function c111310042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c111310042.filter,1,nil,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,eg:GetCount(),0,0)
end
function c111310042.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c111310042.filter,nil,e,tp)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
function c111310042.filter1(c,e,tp)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:GetSummonPlayer()==1-tp and c:IsCanChangePosition()
		and (not e or c:IsRelateToEffect(e))
end
function c111310042.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c111310042.filter1,1,nil,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,eg:GetCount(),0,0)
end
function c111310042.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c111310042.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2
end
function c111310042.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end