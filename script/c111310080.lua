--소원새장의 감시자
function c111310080.initial_effect(c)
	--융합 소환
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c111310080.ffilter,2,true)	
	--장착
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310080,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(c111310080.eqcon)
	e1:SetTarget(c111310080.eqtg)
	e1:SetOperation(c111310080.eqop)
	c:RegisterEffect(e1)
	--효과 발동 제약
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c111310080.aclimit)
	c:RegisterEffect(e2)
end
function c111310080.ffilter(c,fc,sub,mg,sg)
	return (not sg or sg:FilterCount(aux.TRUE,c)==0 or (sg:IsExists(Card.IsLevel,1,c,c:GetLevel())) and c:GetLevel()>0)
end
function c111310080.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_FUSION
end
function c111310080.eqfilter(c,mat)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToChangeControler()
		and mat:IsExists(Card.IsLevel,1,nil,c:GetLevel()) and c:GetLevel()>0
end
function c111310080.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mat=e:GetHandler():GetMaterial()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(1-tp) and c111310080.eqfilter(chkc,mat) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c111310080.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,mat) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c111310080.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,mat)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c111310080.eqlimit(e,c)
	return e:GetOwner()==c
end
function c111310080.equip_monster(c,tp,tc)
	if not Duel.Equip(tp,tc,c,false) then return end
	--Add Equip limit
	tc:RegisterFlagEffect(111310080,RESET_EVENT+RESETS_STANDARD,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c111310080.eqlimit)
	tc:RegisterEffect(e1)
end
function c111310080.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if (tc:IsLocation(LOCATION_GRAVE) or tc:IsFaceup()) and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then
		c111310080.equip_monster(c,tp,tc)
	end
end
function c111310080.aclimit(e,re,tp)
	local eq=e:GetHandler():GetEquipGroup()
	local c=re:GetHandler()
	local lv=c:GetLevel()
	local chk=false
	local tc=eq:GetFirst()
	while tc do
		if tc:GetFlagEffect(111310080)~=0 and tc:GetLevel()==lv then
			chk=true
		end
		tc=eq:GetNext()
	end
	if c:IsType(TYPE_XYZ+TYPE_LINK) then chk=false end
	return re:IsActiveType(TYPE_MONSTER) and chk==true
end