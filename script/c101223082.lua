--이상향의 관측자
function c101223082.initial_effect(c)
	--소재 전부 회수
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_LEAVE_FIELD_P)
	e1:SetTarget(c101223082.checktg)
	e1:SetOperation(c101223082.checkop)
	c:RegisterEffect(e1)	
	--파괴 대체
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c101223082.reptg)
	e2:SetOperation(c101223082.repop)
	c:RegisterEffect(e2)
end
function c101223082.chkfilter(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayGroupCount()>0
end
function c101223082.checktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101223082.chkfilter,1,nil) end
end
function c101223082.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101223082.chkfilter,nil)
	if g:GetCount()>1 then
		local g1=Group.CreateGroup()
		local tc=g:GetFirst()
		while tc do
			g:Merge(tc:GetOverlayGroup())
			tc=g:GetNext()
		end
		if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
		end
	end
end
function c101223082.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c101223082.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
