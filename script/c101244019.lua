--패러리얼의 관리자
function c101244019.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,c101244019.ffilter,3,3,c101244019.ffilter1,c101244019.ffilter2,c101244019.ffilter2,c101244019.ffilter2)
	--융합 소환시 종족 변경
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101244019.rccon)
	e1:SetOperation(c101244019.rcop)
	c:RegisterEffect(e1)
	--관리자 메세지
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101244019.mscon)
	e2:SetOperation(c101244019.msop)
	c:RegisterEffect(e2)
	--세트 뺏기
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101244019,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c101244019.sthtg)
	e3:SetOperation(c101244019.sthop)
	c:RegisterEffect(e3)
	--상대 필드 클린
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c101244019.descon)
	e4:SetTarget(c101244019.destg)
	e4:SetOperation(c101244019.desop)
	c:RegisterEffect(e4)	
end
function c101244019.ffilter(c,fc)
	return c:IsType(TYPE_MONSTER) and c:GetOwner()==fc:GetControler()
end
function c101244019.ffilter1(c,fc)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x61e)
end
function c101244019.ffilter2(c,fc)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101244019.rccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mat=c:GetMaterial()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and mat:IsExists(Card.IsType,1,nil,TYPE_FUSION)
end
function c101244019.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--트리슈라식 강탈
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101244019,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101244019.thtg)
	e1:SetOperation(c101244019.thop)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	c:RegisterEffect(e2)
end
function c101244019.mscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_FUSION and c:GetSummonLocation()==LOCATION_EXTRA
end
function c101244019.msop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 베이지색의 관리자가 감지되었습니다.")
end
function c101244019.filter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function c101244019.sthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101244019.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101244019.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101244019.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101244019.sthop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end
function c101244019.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c101244019.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_GRAVE,nil)
	local g3=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(101244019,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(101244019,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(101244019,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:RandomSelect(tp,1)
		sg:Merge(sg3)
	end
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
end
function c101244019.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE)
		or (rp==1-tp and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp)
end
function c101244019.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101244019.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end