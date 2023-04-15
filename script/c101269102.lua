--CR(크로니클 레플리카)-지옥화의 후회 파르테리스
c101269102.AccessMonsterAttribute=true
function c101269102.initial_effect(c)
   --액세스 소환
   cyan.AddAccessProcedure(c,c101269102.afil1,c101269102.afil2)
   c:EnableReviveLimit()
   --공격력 절반
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_SINGLE)
   e1:SetRange(LOCATION_MZONE)
   e1:SetCode(EFFECT_SET_BASE_ATTACK)
   e1:SetCondition(cyan.adcon)
   e1:SetValue(2300)
   c:RegisterEffect(e1)
   --대상이 되었을 때
   local e2=Effect.CreateEffect(c)
   e2:SetDescription(aux.Stringid(101269102,0))
   e2:SetCategory(CATEGORY_NEGATE)
   e2:SetType(EFFECT_TYPE_QUICK_O)
   e2:SetCode(EVENT_BECOME_TARGET)
   e2:SetRange(LOCATION_MZONE)
   e2:SetCondition(c101269102.negcon)
   e2:SetCost(c101269102.negcost)
   e2:SetTarget(c101269102.negtg)
   e2:SetOperation(c101269102.negop)
   c:RegisterEffect(e2)
   --번
   local e3=Effect.CreateEffect(c)
   e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   e3:SetCode(EVENT_CHAINING)
   e3:SetRange(LOCATION_MZONE)
   e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
   e3:SetOperation(c101269102.regop)
   c:RegisterEffect(e3)
   local e4=Effect.CreateEffect(c)
   e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   e4:SetCode(EVENT_CHAIN_SOLVED)
   e4:SetRange(LOCATION_MZONE)
   e4:SetCondition(c101269102.damcon)
   e4:SetOperation(c101269102.damop)
   c:RegisterEffect(e4)
end
function c101269102.afil1(c)
   return c:IsRace(RACE_SPELLCASTER)
end
function c101269102.afil2(c)
   return c:IsSetCard(0x641)
end
function c101269102.negcon(e,tp,eg,ep,ev,re,r,rp)
   return eg:IsContains(e:GetHandler())
end
function c101269102.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
   local ad=e:GetHandler():GetAdmin()
   if chk==0 then return ad~=nil end
   Duel.SendtoGrave(ad,REASON_COST)
   if ad:IsRace(RACE_SPELLCASTER) then e:SetLabel(1) end
end
function c101269102.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
   Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
   if e:GetLabel()==1 then
      Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,1,tp,LOCATION_EXTRA)
   end
end
function c101269102.negop(e,tp,eg,ep,ev,re,r,rp)
   Duel.NegateEffect(ev)
   if e:GetLabel()==1 then
      local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_EXTRA,nil)
      g=g:RandomSelect(tp,1,1,nil)
      Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
   end
end
function c101269102.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
   Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c101269102.tgop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
   local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
   if g:GetCount()>0 then
      Duel.Destroy(g,REASON_EFFECT)
      Duel.Recover(tp,800,REASON_EFFECT)
   end
end
function c101269102.regop(e,tp,eg,ep,ev,re,r,rp)
   e:GetHandler():RegisterFlagEffect(101269102,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c101269102.damcon(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   return ep~=tp and c:GetFlagEffect(101269102)~=0
       and re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101269102.damop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_CARD,0,101269102)
   Duel.Damage(1-tp,600,REASON_EFFECT)
end
