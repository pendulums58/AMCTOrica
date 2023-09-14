--프로세스 컨덕터
function c101223091.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223091.pfilter,c101223091.mfilter,1,99)
	c:EnableReviveLimit()		
	--앞면으로 한다
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(cyan.PairSSCon)
	e1:SetTarget(c101223091.tg)
	e1:SetOperation(c101223091.op)
	c:RegisterEffect(e1)
	--파괴 대체
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c101223091.reptg)
	c:RegisterEffect(e2)
end
function c101223091.pfilter(c)
	return c:IsRace(RACE_PSYCHO)
end
function c101223091.mfilter(c,pair)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSetCardList(pair)
end
function c101223091.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_REMOVED,0,1,nil) end
	local ct=c:GetMaterialCount()
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_REMOVED,0,1,ct,nil)
	if c:IsLinkState() then
		e:SetCategory(CATEGORY_DRAW)
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetLabel(0)
	end
end
function c101223091.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:GetCount()>0 then
		local ttc=tg:GetFirst()
		Group.RemoveCard(g,ttc)
		local tcode=ttc:GetCode()
		Duel.Exile(ttc,REASON_EFFECT)
		local token=Duel.CreateToken(tp,tcode)
		Duel.Remove(token,POS_FACEUP,REASON_EFFECT)
		if e:GetLabel()==1 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c101223091.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetDeckTopGroup(tp,2)
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and g:GetCount()==2 end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
