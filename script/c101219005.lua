--라디언트 프레이
local s,id=GetID()
function s.initial_effect(c)
	--의식 소환
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_EQUAL,filter=s.ritualfil,extrafil=s.extrafil,extraop=s.extraop,matfilter=s.forcedgroup,location=LOCATION_HAND,forcedselection=s.ritcheck})
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)	
	--공개 의식
	local e2=Ritual.CreateProc({handler=c,lvtype=RITPROC_EQUAL,filter=s.ritualfil1,matfilter=s.forcedgroup1,location=LOCATION_HAND})
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCondition(cyan.selfpubcon)
	c:RegisterEffect(e2)
end
s.listed_names={101219004}
function s.ritualfil(c)
	return c:IsSetCard(SETCARD_RADIANT)
end
function s.ritualfil(c)
	return c:IsSetCard(SETCARD_RADIANT) and c:IsPublic()
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
function s.forcedgroup1(c,e,tp)
	return c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function s.ritcheck(e,tp,g,sc)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
end
