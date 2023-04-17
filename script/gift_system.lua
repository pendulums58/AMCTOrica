TYPE_GIFT=0x80000000

--기프트 시스템
function Duel.CheckGiftEffect(tp,tf)
	return Duel.IsExistingMatchingCard(Card.EgoCheckFaceup,tp,LOCATION_MZONE,0,1,nil,tf)
end
function Card.EgoCheckFaceup(c,f)
	return c:IsFaceup() and f(c)
end
function Duel.AddGiftEffect(e,tf,f,atk,def)
	local tp=e:GetHandlerPlayer()
	local tc=Duel.SelectMatchingCard(tp,Card.EgoCheckFaceup,tp,LOCATION_MZONE,0,1,1,nil,tf)
	if tc and f then
		local c=tc:GetFirst()
		f(e,c)
		if c:GetAttack()<atk then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)			
		end
		if c:GetDefense()<def then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENSE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(def)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)			
		end
	end
end



--융합 속성 삭제
local cit=Card.IsType
function Card.IsType(c,ty)
	if cit(c,TYPE_GIFT) and bit.band(ty,TYPE_FUSION)==TYPE_FUSION then
		return false
	end
	return cit(c,ty)
end
local cgt=Card.GetType
function Card.GetType(c)
	if cit(c,TYPE_GIFT) then
		local ty=cgt(c)
		return ty-TYPE_FUSION
	end
	return cgt(c)
end