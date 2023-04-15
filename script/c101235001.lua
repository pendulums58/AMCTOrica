--컨티뉴엄 옵저버
function c101235001.initial_effect(c)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101235001,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101235001)
	e1:SetTarget(c101235001.target)
	e1:SetOperation(c101235001.operation)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101235001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101235901)
	e2:SetCost(cyan.relcost)
	e2:SetTarget(c101235001.sptg)
	e2:SetOperation(c101235001.spop)
	c:RegisterEffect(e2)
end
function c101235001.spfilter(c,e,tp)
	return c:IsSetCard(0x653) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101235001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c101235001.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c101235001.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101235001.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101235001.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c101235001.filter(c)
	return c:IsFacedown()
end
function c101235001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil,POS_FACEDOWN)==5 end
end
function c101235001.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,5)
	local tc=g:GetFirst()
	local fid=e:GetHandler():GetFieldID()
	while tc do
		Duel.DisableShuffleCheck()
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		tc:RegisterFlagEffect(101235001,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc=g:GetNext()
	end
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(c101235001.rmcon)
	e1:SetOperation(c101235001.rmop)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local tg=Duel.SelectMatchingCard(tp,c101235001.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	if tg:GetCount()>0 then
		local ttc=tg:GetFirst()
		Group.RemoveCard(g,ttc)
		Card.ResetFlagEffect(ttc,101235001)
		local tcode=ttc:GetCode()
		Duel.Exile(ttc,REASON_EFFECT)
		local token=Duel.CreateToken(tp,tcode)
		Duel.Remove(token,POS_FACEUP,REASON_EFFECT)
	end
end
function c101235001.rmfilter(c,fid)
	return c:GetFlagEffectLabel(101235001)==fid and c:IsLocation(LOCATION_REMOVED)
end
function c101235001.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c101235001.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c101235001.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c101235001.rmfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local ct=tg:GetCount()
	if ct==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=tg:Select(tp,ct,ct,nil)
	Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
	Duel.SortDecktop(tp,tp,ct)
	for i=1,ct do
		local mg=Duel.GetDecktopGroup(tp,1)
		Duel.MoveSequence(mg:GetFirst(),1)
	end
end
