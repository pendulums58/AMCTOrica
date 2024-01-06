--아너 오브 퍼플프레임
local s,id=GetID()
function s.initial_effect(c)
	--융합 소환
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,s.ffilter,3)	
	--특수 소환 조건
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.abcon)
	e0:SetOperation(s.abop)
	c:RegisterEffect(e0)
	--융합 처리중 모든 카드군 소속
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ALL_SETCARD)
	e1:SetCondition(s.con)		
	c:RegisterEffect(e1)
	--융합 소환 성공시
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cyan.FuSSCon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.ffilter(c,fc,sumtype,sp,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0 or (not sg:IsExists(Card.IsNotSetCardList,1,c,c,fc,sumtype,sp))
end
function s.abcon(e,tp,ep,eg,ev,re,r,rp)
	return Duel.GetTurnCount()==1
end
function s.abop(e,tp,ep,eg,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_EXTRA,0,1,c,TYPE_FUSION) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		e1:SetValue(aux.FALSE)
		c:RegisterEffect(e1)
	end
end
function s.con(e)
	return global_fusion_processing==true
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetMaterial():Filter(s.thfilter,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial():Filter(s.thfilter,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local g1=g:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,tp,false,false)
			if g1:GetCount()>0 then
				Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand()
end