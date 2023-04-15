--인터듀오: 글루미 레이디
function c101229002.initial_effect(c)
   --카드명을 바꾸는 효과
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(101229002,0))
   e1:SetCategory(CATEGORY_HANDES)
   e1:SetType(EFFECT_TYPE_IGNITION)
   e1:SetRange(LOCATION_HAND)
   e1:SetCountLimit(1,101229002)
   e1:SetCost(c101229002.cost)
   e1:SetTarget(c101229002.target)
   e1:SetOperation(c101229002.op)
   c:RegisterEffect(e1)
end
function c101229002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return not e:GetHandler():IsPublic() end
end
function c101229002.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c101229002.op(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
   local tc=g:GetFirst()
   while tc do
		Debug.Message(tc:GetCode())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetValue(101229002)
        tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_CODE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetValue(101229003)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
   end
end