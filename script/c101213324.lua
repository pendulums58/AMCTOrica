--시계탑의 집행자
function c101213324.initial_effect(c)
	--엑시즈 소환
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--필드의 카드 파괴
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101213324,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c101213324.descost)
	e1:SetTarget(c101213324.destg)
	e1:SetOperation(c101213324.desop)
	c:RegisterEffect(e1)
	--효과 데미지 봉인
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c101213324.damval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e3)	
end
function c101213324.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101213324.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101213324.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,75041269) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101213324.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101213324.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_ONFIELD,0,1,1,nil,75041269)
		if g:GetCount()>0 then
			tc1=g:GetFirst()
			tc1:AddCounter(0x1b,1)
		end		
	end
end
function c101213324.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandler():GetControler()
	if bit.band(r,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,75041269) then return 0 end
	return val
end