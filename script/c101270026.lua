--검의 종점
local s,id=GetID()
function s.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,s.unlockeff)
	--개방시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_KEY_UNLOCKED)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DELAY)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--공뻥
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end	
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.AnnounceCard(tp,TYPE_EQUIP,OPCODE_ISTYPE)
	local token=Duel.CreateToken(tp,ac)
	Duel.SendtoHand(token,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
end
function s.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.swordop)
	Duel.RegisterEffect(e1,tp)		
end
function s.swordop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and eg:IsExists(s.chk,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		-- 검 리스트
		local swordlist = {101270027,101270028,101270029,101270030,101270031}
		--무작위 검 3개 선택
		local list = Group.CreateGroup()
		local token = 0
		while #list<3 do
			token=swordlist[Duel.GetRandomNumber(1,#swordlist)]
			if not list:IsExists(Card.IsCode,1,nil,token) then
				token=Duel.CreateToken(tp,token)
				list:AddCard(token)
			end			
		end
		local eqc=list:Select(tp,1,1,nil):GetFirst()
		local g1=eg:Filter(s,chk,nil,tp)
		local eq=g1:Select(tp,1,1,nil):GetFirst()
		Duel.MoveToField(eqc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Equip(tp,eqc,eq)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end

	
end
function s.chk(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,0,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,TYPE_EQUIP)*800
end