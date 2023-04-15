--메모리큐어 - 라벤더
function c101249012.initial_effect(c)
   cyan.AddPairingProcedure(c,c101249012.pfilter,c101249012.mfilter,1,1)  
   c:EnableReviveLimit()
   c:SetSPSummonOnce(101249012)

   --소재 후 엑스트라덱으로
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(101249012,0))
   e1:SetType(EFFECT_TYPE_FIELD)
   e1:SetCode(EFFECT_SPSUMMON_PROC)
   e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
   e1:SetTargetRange(POS_FACEUP,0)
   e1:SetRange(LOCATION_GRAVE)
   e1:SetCountLimit(1,101249012)
   e1:SetCondition(c101249012.spcon)
   c:RegisterEffect(e1)
   
   local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101249012,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101249112)
	e2:SetCost(c101249012.cost)
	e2:SetTarget(c101249012.target)
	e2:SetOperation(c101249012.activate)
	c:RegisterEffect(e2)
end
function c101249012.pfilter(c)
   return c:IsLevel(4) and c:IsRace(RACE_FAIRY) and c:IsFaceup()
end
function c101249012.mfilter(c,pair)
   return not c:IsCode(pair:GetCode()) and c:IsLevel(4)
end
function c101249012.filter2(c)
	return c:IsFaceup() and c:IsCode(96765646)
end
function c101249012.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c101249012.filter2,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end

function c101249012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c101249012.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x623)
end
function c101249012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101249012.filter(chkc) end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(c101249012.filter,tp,LOCATION_MZONE,0,1,nil)
			and e:GetHandler():IsCanOverlay()
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101249012.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101249012.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end