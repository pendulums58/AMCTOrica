--삭야관성 - 달빛을 비추는 검
function c101271007.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,4,c101271007.lcheck)
	c:EnableReviveLimit()
	--이 카드는 필드에 1장밖에 존재할 수 없음
	c:SetUniqueOnField(1,0,33015627)
	
	--이 카드가 필드에 존재하는 한 몹존 3장 못씀
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c101271007.disop)
	c:RegisterEffect(e1)
	
	--1/3번 존에 있으면 전투 파괴가 안됌
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c101271007.actcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	--2/4번 존에 있으면 상대 카드 대상 x 밑 효과로 파괴 안됌
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	e3:SetCondition(c101271007.indcon)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c101271007.indcon)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)

end
--1번 효과 적용
function c101271007.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x642)
end
function c101271007.disop(e,tp)
	local c=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	if c==0 then return end
	local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	if c>1 and Duel.SelectYesNo(tp,aux.Stringid(101271007,0)) then
		local dis2=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,dis1)
		dis1=bit.bor(dis1,dis2)
		if c>2 and Duel.SelectYesNo(tp,aux.Stringid(101271007,0)) then
			local dis3=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,dis1)
			dis1=bit.bor(dis1,dis3)
		end
	end
	return dis1
end
function c101271007.actcon(e)
	local c=e:GetHandler()
	return c:GetSequence()==0 or c:GetSequence()==2 or c:GetSequence()==4
end
function c101271007.indcon(e)
	local c=e:GetHandler()
	return c:GetSequence()==1 or c:GetSequence()==3
end