--N(노블).컨티뉴엄-리텔
function c101235006.initial_effect(c)
	c:SetSPSummonOnce(101235006)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101235006.matfilter,1,1)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101235006,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,101235006)
	e4:SetTarget(c101235006.thtg)
	e4:SetOperation(c101235006.thop)
	c:RegisterEffect(e4)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101235006,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,101235906)
	e2:SetCost(c101235006.cost)
	e2:SetTarget(c101235006.tdtg)
	e2:SetOperation(c101235006.tdop)
	c:RegisterEffect(e2)
end
function c101235006.matfilter(c)
	return c:IsLinkSetCard(0x653)
end
function c101235006.thfilter(c)
	return c:IsFacedown()
end
function c101235006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101235006.thfilter,tp,LOCATION_REMOVED,0,3,nil) end
end
function c101235006.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101235006.thfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local tcode=tc:GetCode()
			Duel.Exile(tc,REASON_EFFECT)
			local token=Duel.CreateToken(tp,tcode)
			Duel.Remove(token,POS_FACEUP,REASON_EFFECT)
			tc=g:GetNext()
		end
	end
end
function c101235006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() end
	Duel.SendtoGrave(c,REASON_COST+REASON_RETURN)
end
function c101235006.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101235006.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
