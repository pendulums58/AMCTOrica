--수렵 길드
local s,id=GetID()
function s.initial_effect(c)
   --발동
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_ACTIVATE)
   e1:SetCode(EVENT_FREE_CHAIN)
   c:RegisterEffect(e1)
   --토큰 생성
   local e2=Effect.CreateEffect(c)
   e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
   e2:SetType(EFFECT_TYPE_IGNITION)
   e2:SetRange(LOCATION_FZONE)
   e2:SetDescription(aux.Stringid(id,0))
   e2:SetCountLimit(1)
   e2:SetCondition(s.spcon)
   e2:SetTarget(s.sptg)
   e2:SetOperation(s.spop)
   c:RegisterEffect(e2)
   --마함존 특소
   local e3=Effect.CreateEffect(c)
   e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
   e3:SetType(EFFECT_TYPE_IGNITION)
   e3:SetRange(LOCATION_FZONE)
   e3:SetDescription(aux.Stringid(id,1))
   e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
   e3:SetCountLimit(1)
   e3:SetTarget(s.sptg1)
   e3:SetOperation(s.spop1)
   c:RegisterEffect(e3)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
   return not Duel.IsExistingMatchingCard(s.spchk,tp,0,LOCATION_MZONE,1,nil)
end
function s.spchk(c)
   local lv=c:GetLevel()
   if c:IsType(TYPE_XYZ) then lv=c:GetRank() end
   return lv>=8
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 
      and Duel.IsPlayerCanSpecialSummonMonster(tp,s+99,0xf,0x4011,0,0,8,RACE_DRAGON,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)end
   
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if c:IsRelateToEffect(e) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
      local token=Duel.CreateToken(tp,s+99)
      Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
      e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
      e1:SetValue(1)
      token:RegisterEffect(e1)
      Duel.SpecialSummonComplete()
   end
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and s.spfilter(chkc,e,tp) end
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
   local tc=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_SZONE)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
   local tc=Duel.GetFirstTarget()
   if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
      Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
   end
end
function s.spfilter(c,e,tp)
   local ty=c:GetOriginalType()
   return bit.band(ty,TYPE_MONSTER)==TYPE_MONSTER and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false)
end