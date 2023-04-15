--흑백의 인도자 홀로기움
function c101225013.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2,c101225013.ovfilter,aux.Stringid(101225013,0),2,c101225013.xyzop)
	c:EnableReviveLimit()	
	--내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101225013.efilter)
	c:RegisterEffect(e1)
	--삐슈웅
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(101225013,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101225013)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c101225013.target)
	e2:SetOperation(c101225013.operation)
	c:RegisterEffect(e2)
	--상대 턴에도 삐슈웅
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e3:SetDescription(aux.Stringid(101225013,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)	
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,101225013)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101225013.condition)
	e3:SetTarget(c101225013.target)
	e3:SetOperation(c101225013.operation)
	c:RegisterEffect(e3)	
end
function c101225013.cfilter(c)
	return c:IsCode(31677606) and c:IsDiscardable()
end
function c101225013.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSetCard(0x60b,lc,SUMMON_TYPE_XYZ,tp) and c:IsRank(5)
end
function c101225013.xyzop(e,tp,chk,mc)
	if chk==0 then return Duel.IsExistingMatchingCard(c101225013.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=Duel.GetMatchingGroup(c101225013.cfilter,tp,LOCATION_HAND,0,nil):SelectUnselect(Group.CreateGroup(),tp,false,Xyz.ProcCancellable)
	if tc then
		Duel.SendtoGrave(tc,REASON_DISCARD+REASON_COST)
		return true
	else return false end
end
function c101225013.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c101225013.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
end
function c101225013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101225013.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end