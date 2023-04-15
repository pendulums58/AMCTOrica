--라디언트 프레이
local s,id=GetID()
function s.initial_effect(c)
	--의식 소환
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_EQUAL,filter=s.ritualfil,extrafil=s.extrafil,extraop=s.extraop,matfilter=s.forcedgroup,location=LOCATION_HAND,forcedselection=s.ritcheck})
	c:RegisterEffect(e1)	
	--회수
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_names={101219004}
function s.ritualfil(c)
	return c:IsSetCard(SETCARD_RADIANT)
end
function s.exfilter0(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelAbove(1) and c:IsAbleToRemove()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsExistingMatchingCard(s.exchk,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) then
		return Duel.GetMatchingGroup(s.exfilter0,tp,LOCATION_GRAVE,0,nil)
	end
end
function s.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	local mat2=mg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	mg:Sub(mat2)
	Duel.ReleaseRitualMaterial(mg)
	Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function s.exchk(c)
	return c:IsCode(101219004) or (c:IsSetCard(SETCARD_RADIANT) and c:IsLevel(12))
end
function s.forcedgroup(c,e,tp)
	return c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD) or (s.exfilter0(c) and c:IsLocation(LOCATION_GRAVE))
end
function s.ritcheck(e,tp,g,sc)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsPublic,tp,LOCATION_HAND,0,nil)>2
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)			
	end
end