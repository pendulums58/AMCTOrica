--신비의 영역
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--공격력 상승
	local e2=Effect.CreateEffect(c)
	e2:SetRange(LOCATION_FZONE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.atkval)
	e2:SetTarget(s.atktg)
	e2:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e2)
	--특수 소환
	local e3=Effect.CreateEffect(c)
	e3:SetRange(LOCATION_FZONE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetTarget(s.seqtg)
	e3:SetOperation(s.seqop)
	c:RegisterEffect(e3)
	--공격력 상승 2
	local e4=Effect.CreateEffect(c)
	e4:SetRange(LOCATION_FZONE)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(8000)
	e4:SetTarget(s.atktg)
	e4:SetCondition(s.atkcon)
	e4:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e4)
end
function s.atktg(e,c)
	return c:IsSetCard(SETCARD_MYSTERY)
end
function s.atkval(e,c)
	local atk=c:GetColumnGroup():Filter(s.atkchk,nil,c:GetControler()):GetSum(Card.GetAttack)
	return atk
end
function s.atkchk(c)
	return c:IsControler(1-tp) and c:IsType(TYPE_MONSTER)
end
function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(tp) or tc:IsImmuneToEffect(e) or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	Duel.MoveSequence(tc,math.log(Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)>>16,2))
	Duel.BreakEffect()
	local g=tc:GetColumnGroup()
	if g:IsExists(s.chk,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local g1=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.chk(c,tp)
	return c:IsControler(tp) and c:IsSetCard(SETCARD_MYSTERY)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(SETCARD_MYSTERY)
end
function s.atkcon(e)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.atkchk1,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>9
end
function s.atkchk1(c)
	return c:IsSetCard(SETCARD_MYSTERY) and c:IsType(TYPE_MONSTER)
end