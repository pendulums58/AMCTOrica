--패러리얼 렐름파인더
function c101244012.initial_effect(c)
	--융합 소환
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,c101244012.twfilter,c101244012.twfilter1,1,true,true)
	--내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c101244012.efilter)
	c:RegisterEffect(e1)
	--엑덱 특소 불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c101244012.discon)
	e2:SetTarget(c101244012.splimit)
	c:RegisterEffect(e2)
	--퓨전 회수
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101244012,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c101244012.con)
	e3:SetTarget(c101244012.thtg)
	e3:SetOperation(c101244012.thop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(101244012,ACTIVITY_CHAIN,c101244012.chainfilter)
end
function c101244012.twfilter(c)
	return c:IsType(TYPE_TRAP)
end
function c101244012.twfilter1(c)
	return c:IsSetCard(0x61e) and c:IsType(TYPE_MONSTER)
end
function c101244012.efilter(e,te)
	local c=e:GetHandler()
	return te:GetHandler():GetControler()~=c:GetControler() and te:GetOwner()~=e:GetOwner()
end
function c101244012.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c101244012.discon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetCustomActivityCount(101244012,tp,ACTIVITY_CHAIN)==0
end
function c101244012.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_TRAP)
end
function c101244012.thfilter(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c101244012.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c101244012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101244012.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101244012.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101244012.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101244012.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end