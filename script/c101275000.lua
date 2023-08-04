--수렵자 니나
local s,id=GetID()
function s.initial_effect(c)
   --세트
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
   e1:SetCode(EVENT_SUMMON_SUCCESS)
   e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
   e1:SetCountLimit(1,id)
   e1:SetTarget(s.sstg)
   e1:SetOperation(s.ssop)
   c:RegisterEffect(e1)
   local e2=e1:Clone()
   e2:SetCode(EVENT_SPSUMMON_SUCCESS)
   c:RegisterEffect(e2)
   --공통효과
   local e3=Effect.CreateEffect(c)
   e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
   e3:SetRange(LOCATION_SZONE)
   e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
   e3:SetCode(EVENT_CHAINING)
   e3:SetProperty(EFFECT_FLAG_DELAY)
   e3:SetCountLimit(1,{id,1})
   e3:SetCondition(s.spcon)
   e3:SetTarget(s.sptg)
   e3:SetOperation(s.spop)
   c:RegisterEffect(e3)
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
      and Duel.IsExistingMatchingCard(s.ssfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
   if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
      local g=Duel.SelectMatchingCard(tp,s.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil)
      if g:GetCount()>0 then
         Duel.SSet(tp,g)
      end
   end
end
function s.ssfilter(c)
   return c:IsSetCard(SETCARD_HUNTTOOL) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
   return YiPi.HunterSpChk(e:GetHandler())
      and Duel.IsExistingMatchingCard(YiPi.HunterCheck,tp,0,LOCATION_MZONE,1,nil) and ep==1-tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
   
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
   local e1=Effect.CreateEffect(e:GetHandler())
   e1:SetType(EFFECT_TYPE_FIELD)
   e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
   e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT)
   e1:SetCountLimit(1,{id,2})
   e1:SetTargetRange(LOCATION_SZONE,0)
   e1:SetReset(RESET_PHASE+PHASE_END)
   Duel.RegisterEffect(e1,tp)
   local e2=e1:Clone()
   e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
   Duel.RegisterEffect(e2,tp)
   YiPi.HunterEffect(e)
end