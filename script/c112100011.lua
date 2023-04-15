--홍의 파색 라그랑주
local s,id=GetID()
function s.initial_effect(c)
   --속성 변경
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_QUICK_O)
   e1:SetCode(EVENT_FREE_CHAIN)
   e1:SetCountLimit(1)
   e1:SetRange(LOCATION_MZONE)
   e1:SetCost(s.attcost)
   e1:SetTarget(s.atttg)
   e1:SetOperation(s.attop)
   c:RegisterEffect(e1)
   --묘지 소생
   local e2=Effect.CreateEffect(c)
   e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
   e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
   e2:SetCode(EVENT_LEAVE_FIELD)
   e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
   e2:SetRange(LOCATION_GRAVE)
   e2:SetCountLimit(1,id)
   e2:SetCondition(s.spcon)
   e2:SetTarget(s.sptg)
   e2:SetOperation(s.spop)
   c:RegisterEffect(e2)
end
s.listed_names={CARD_TIMEMAKERS_VOID}
function s.attcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
   local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
   if g:GetCount()>0 then
      Duel.SendtoGrave(g,REASON_COST)
   end
end
function s.cfilter(c)
   return c:IsAbleToGraveAsCost() and c:IsCode(CARD_TIMEMAKERS_VOID)
end
function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
   if chk==0 then return true end
   local att=c:AnnounceAnotherAttribute(tp)
   e:SetLabel(att)
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if c:IsRelateToEffect(e) then
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_ADD_ATTRIBUTE)
      e1:SetValue(e:GetLabel())
      e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
      c:RegisterEffect(e1)
   end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
   return eg:IsExists(s.spchk,1,nil)
end
function s.spchk(c)
   return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x65b)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
      and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
      Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_FIELD)
      e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
      e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
      e1:SetTargetRange(1,0)
      e1:SetTarget(s.splimit)
      e1:SetReset(RESET_PHASE+PHASE_END)
      Duel.RegisterEffect(e1,tp)   
   end
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
   return not (c:IsLevel(1) or c:IsRank(1) or c:IsLink(1))
end
