--결속의 선도자
local s,id=GetID()
function s.initial_effect(c)
    --특소
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
    --기동
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCost(s.cost)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,id+100)
    e2:SetTarget(s.tg)
    e2:SetOperation(s.op)
    c:RegisterEffect(e2)
end
s.listed_names={CARD_TIMEMAKERS_VOID}
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and    Duel.IsExistingMatchingCard(aux.TRUE,c:GetControler(),LOCATION_FZONE,0,1,nil)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
    local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_COST)
    end
end
function s.cfilter(c)
    return c:IsCode(CARD_TIMEMAKERS_VOID) and c:IsAbleToGraveAsCost()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_FZONE) and c:IsFaceup() and c:IsControler(tp) end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_FZONE,0,1,nil) end
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_FZONE,0,1,1,nil)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Maneuver(e,tc,REASON_EFFECT)
    end
end

