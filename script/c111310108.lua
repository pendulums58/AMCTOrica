--루나피스 컨덕터
c111310108.AccessMonsterAttribute=true
function c111310108.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310108.afil1,c111310108.afil2)
	c:EnableReviveLimit()	
	--무효
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c111310108.distg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c111310108.distg)
	c:RegisterEffect(e2)
	--위치 이동
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111310108,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c111310108.seqtg)
	e3:SetOperation(c111310108.seqop)
	c:RegisterEffect(e3)
end
function c111310108.afil1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c111310108.afil2(c)
	return c:GetSequence()<5
end
function c111310108.distg(e,c)
	local tp=e:GetHandlerPlayer()
	local rp=c:GetControler()
	local seq=c:GetSequence()
	local g=e:GetHandler():GetColumnGroup()
	return g:IsContains(c)
end
function c111310108.seqfilter(c,ad)
	local tp=c:GetControler()
	return c:IsFaceup() and c:GetSequence()<5 and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
		and c:IsAttribute(ad:GetAttribute())
end
function c111310108.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if chkc then return ad and chkc:IsLocation(LOCATION_MZONE) and c111310108.seqfilter(chkc,ad) end
	if chk==0 then return ad and Duel.IsExistingTarget(c111310108.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ad) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(111310108,1))
	Duel.SelectTarget(tp,c111310108.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ad)
end
function c111310108.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ad=e:GetHandler():GetAdmin()
	if ad==nil then return end
	local ttp=tc:GetControler()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e)
		or Duel.GetLocationCount(ttp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	local p1,p2
	if tc:IsControler(tp) then
		p1=LOCATION_MZONE
		p2=0
	else
		p1=0
		p2=LOCATION_MZONE
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local seq=math.log(Duel.SelectDisableField(tp,1,p1,p2,0),2)
	if tc:IsControler(1-tp) then seq=seq-16 end
	Duel.MoveSequence(tc,seq)
end