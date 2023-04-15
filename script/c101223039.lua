--어두운 존재증명자
function c101223039.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,aux.TRUE,c101223039.mfilter,3,3)
	c:EnableReviveLimit()	
	--소환시 효과
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101223039.con)
	e1:SetTarget(c101223039.tg)
	e1:SetOperation(c101223039.op)
	c:RegisterEffect(e1)
	--전투시 효과
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31801517,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101223039.atkcon)
	e2:SetTarget(c101223039.atktg)
	e2:SetOperation(c101223039.atkop)
	c:RegisterEffect(e2)
end
function c101223039.mfilter(c,pair)
	return c:IsAttribute(pair:GetAttribute())
end
function c101223039.con(e,tp,eg,ep,ev,re,r,rp)
	return c:IsSummonType(SUMMON_TYPE_PAIRING)
end
function c101223039.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c101223039.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_ATOHAND)
		local sg=g:Select(1-p,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
			
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		g:Sub(sg)
		Duel.DisableShuffleCheck(false)
		Duel.SortDecktop(tp,tp,2)
	end
end
function c101223039.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function c101223039.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetDecktopGroup(tp,1)
		return g:GetCount()==1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c101223039.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ConfirmDecktop(tp,1)
		local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local g=Duel.GetDecktopGroup(tp,1)
		if g:GetFirst():IsCode(ac) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
			c:RegisterEffect(e1)		
		end
	end
end