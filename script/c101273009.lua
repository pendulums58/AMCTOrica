--하늘은 만물을 움직인다
function c101273009.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetCondition(aux.dscon)
    e1:SetCountLimit(1,101273009)
    e1:SetTarget(c101273009.target)
    e1:SetOperation(c101273009.activate)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetDescription(aux.Stringid(101273009,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,101274009)
    e2:SetTarget(c101273009.tdtg)
    e2:SetOperation(c101273009.tdop)
    c:RegisterEffect(e2)
end
function c101273009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
   if chkc then return chkc:IsLocation() and c101273009.nfilter(chkc) end
   if chk==0 then return Duel.IsExistingTarget(c101273009.nfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
   local g=Duel.SelectTarget(tp,c101273009.nfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
   Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101273009.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
   if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
   Duel.ConfirmDecktop(tp,1)
   local g=Duel.GetDecktopGroup(tp,1)
   local tc=g:GetFirst()
   if tc:IsSetCard(0x645) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  then  
    Duel.DisableShuffleCheck()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
      end
   end
end
end
function c101273009.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeck() end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c101273009.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
        Duel.DisableShuffleCheck()
        Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
    end
end