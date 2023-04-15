--메모리파인더 - 히아신스
function c101249011.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FALSE,10,3,c101249011.ovfilter,aux.Stringid(101249011,0),3,c101249011.xyzop)
	c:EnableReviveLimit()
	--엑시즈 소재 보충
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101249006,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c101249011.matcon)
	e3:SetTarget(c101249011.mattg)
	e3:SetOperation(c101249011.matop)
	c:RegisterEffect(e3)
	--무효
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c101249011.discon)
	e4:SetCost(c101249011.discost)
	e4:SetTarget(c101249011.distg)
	e4:SetOperation(c101249011.disop)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c101249011.cost)
	e5:SetTarget(c101249011.target1)
	e5:SetOperation(c101249011.operation1)
	c:RegisterEffect(e5)
end
function c101249011.ovfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_XYZ) and c:IsSetCard(0x623))
end
function c101249011.xyzop(e,tp,chk,mc)
	local g=Duel.GetMatchingGroup(c101249011.costfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,mc)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=4 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	aux.GCheckAdditional=aux.dncheck
	local rg=g:SelectSubGroup(tp,aux.TRUE,false,4,4)
	aux.GCheckAdditional=nil
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c101249011.costfilter2(c)
	return c:IsFaceup() and (c:IsSetCard(0x623) and c:IsType(TYPE_MONSTER)) or c:IsCode(96765646)
end
--상대 효과 안받음 관련
function c101249011.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--엑시즈 소재 보충 관련
function c101249011.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c101249011.matfilter(c,e)
	return c:IsSetCard(0x623) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e)) or c:IsCode(96765646)
end
function c101249011.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101249011.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c101249011.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c101249011.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil,e)
	if g:GetCount()>=0 then
		Duel.Overlay(e:GetHandler(),g)
	end
end
function c101249011.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c101249011.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101249011.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101249011.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end
function c101249011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c101249011.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101249011.operation1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==1 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
	end
end