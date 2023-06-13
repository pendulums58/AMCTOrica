--라그나로크의 불씨 피닉스
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_FIRE),1,1,Synchro.NonTuner(nil),2,99)
	c:EnableReviveLimit()
    --특소
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(s.spcon)
    e1:SetCountLimit(1,id)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)    
    c:RegisterEffect(e1)
	--창염 세트
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{1,id})
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)		
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler():IsCode(112200000) 
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
    if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,#g,s.rescon,0)
        or Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
    if Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and
        Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        local rg=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil) 
		Duel.Release(rg,REASON_COST)
    else
        local rg=aux.SelectUnselectGroup(g,e,tp,1,#g,s.rescon,1,tp,HINTMSG_REMOVE,s.rescon,nil,false) 
		Duel.Release(rg,REASON_COST)
    end
end
function s.rescon(sg,e,tp,mg,c)
    local sum=sg:GetSum(Card.GetLevel)
    return aux.ChkfMMZ(1)(sg,nil,tp) and sum==8,sum>8
end
function s.cfilter(c)
    return c:IsReleasable() and c:HasLevel() and aux.SpElimFilter(c,true,true) and not c:IsType(TYPE_TUNER)
end
function s.cfilter1(c)
    return c:IsCode(112200008)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,s,false,POS_FACEUP) end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,s.repop)	
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	Duel.Destroy(eg,REASON_EFFECT)
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		end
end
function s.setfilter(c,mc,tp)
	return c:IsCode(112200008) and c:IsSSetable()
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local sc=g:GetFirst()
	if sc and Duel.SSet(tp,sc)~=0 then
	end
end