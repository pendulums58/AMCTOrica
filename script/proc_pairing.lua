SUMMON_TYPE_PAIRING=0x40005000
TYPE_PAIRING=0x40000000
REASON_PAIRING=0x40000000
EFFECT_PRE_PAIRED=506
EFFECT_COMP_PAIRED=507
EFFECT_INDESTRUCTABLE_PAIR=508
REASON_PAIR=0x80000000
EFFECT_EXTRA_PAIR=509
EFFECT_DOUBLE_PMAT=510
EFFECT_PAIR_DISCOUNT=511

function cyan.AddPairingProcedure(c,pairf,matf,matcmin,matcmax)
	if matcmax==nil then matcmax=99 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_PAIRING)
	e1:SetCondition(cyan.PairingCondition(pairf,matf,matcmin,matcmax))
	e1:SetTarget(cyan.PairingTarget(pairf,matcmin,matcmax,matf))
	e1:SetOperation(cyan.PairingOperation())
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_NEGATED)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cyan.prepaircancel)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(cyan.paircomplete)
	c:RegisterEffect(e3)
	--페어 룰(대신 파괴)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetTarget(cyan.reptg)
	e4:SetValue(cyan.repval)
	e4:SetOperation(cyan.repop)
	c:RegisterEffect(e4)
end

function cyan.PairingCondition(pairf,matf,matcmin,matcmax)
	return function(e)
		local c=e:GetHandler()
		local tp=c:GetControler()
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		return Duel.IsExistingMatchingCard(cyan.PairingCheckFilter,tp,LOCATION_MZONE,0,1,nil,tp,pairf,matcmin,matf,c)
		or Duel.IsExistingMatchingCard(cyan.OppoPairFilter,tp,0,LOCATION_MZONE,1,nil,tp,pairf,matcmin,matf,c)
	end
end
function cyan.PairingCheckFilter(c,tp,pairf,matcmin,matf,pc)
	local ct=matcmin
	local le={c:IsHasEffect(EFFECT_PAIR_DISCOUNT)}
	for _,te in pairs(le) do			
		local f1=te:GetValue()
		if type(f1)=="function" then f1=f1(te,pc) end
		ct=ct-f1
	end
	if ct<1 then ct=1 end
	return pairf(c) and Duel.IsExistingMatchingCard(cyan.PairingCheckFilter1,tp,LOCATION_MZONE,0,ct,c,tp,matf,c)
end
function Card.IsPMatCount(c)
	if c:IsHasEffect(EFFECT_DOUBLE_PMAT) then
		return 2
	end
	return 1
end
function cyan.OppoPairFilter(c,tp,pairf,matcmin,matf,pc)
	local chk=0
	local le={c:IsHasEffect(EFFECT_EXTRA_PAIR)}
	for _,te in pairs(le) do			
		local f=te:GetValue()	
		if type(f)=="function" then f=f(te,pc,c,tp) end
		if f then chk=1 end
	end	
	return pairf(c) and Duel.IsExistingMatchingCard(cyan.PairingCheckFilter1,tp,LOCATION_MZONE,0,matcmin,c,tp,matf,c)
		and chk==1 
end
function cyan.PairingCheckFilter1(c,tp,matf,pr)
	return matf(c,pr) and c:IsCanBePairingMaterial()
end
function cyan.PairingTarget(pairf,matcmin,matcmax,matf)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c)
		local pg=Duel.GetMatchingGroup(cyan.PairingCheckFilter,tp,LOCATION_MZONE,0,nil,tp,pairf,matcmin,matf,c)
		local og=Duel.GetMatchingGroup(cyan.OppoPairFilter,tp,0,LOCATION_MZONE,nil,tp,pairf,matcmin,matf,c)
		pg:Merge(og)
		Duel.Hint(HINT_SELECTMSG,tp,681)
		local cancel=Duel.GetCurrentChain()==0
		local pr=pg:Select(tp,1,1,nil)
		local ct=matcmin
		local tc=pr:GetFirst()
		local le={tc:IsHasEffect(EFFECT_PAIR_DISCOUNT)}
		for _,te in pairs(le) do			
			local f1=te:GetValue()
			if type(f1)=="function" then f1=f1(te,c) end
			ct=ct-f1
		end
		if ct<1 then ct=1 end
		local mg=Duel.GetMatchingGroup(cyan.PairingCheckFilter1,tp,LOCATION_MZONE,0,tc,tp,matf,tc)
	--	local sg=mg:SelectSubGroup(tp,aux.TRUE,cancel,ct,matcmax)
		local sg=aux.SelectUnselectGroup(mg,e,tp,ct,matcmax,aux.TRUE,1,tp,0,aux.TRUE,nil,true)
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e0:SetCode(EFFECT_PRE_PAIRED)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			e0:SetLabelObject(c)
			tc:RegisterEffect(e0)
			return true
		else
			return false
		end
	end
end
function cyan.PairingOperation()
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_PAIRING)
		local tc=g:GetFirst()
		while tc do
			Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,e,REASON_PAIRING,tp,tp,0)
			tc=g:GetNext()
		end
		Duel.RaiseEvent(g,EVENT_BE_MATERIAL,e,REASON_PAIRING,tp,tp,0)
		g:DeleteGroup()
	end
end


function Card.IsCanBePairingMaterial(c)
	--임시
	return true
end
function Card.GetPair(c)
	local pg=Group.CreateGroup()
	local tp=c:GetControler()
	if c:IsType(TYPE_PAIRING) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local le={tc:IsHasEffect(EFFECT_COMP_PAIRED)}
			for _,te in pairs(le) do
				local pr=te:GetLabelObject()
				if pr and pr==c then pg:AddCard(tc) end 
			end	
			tc=g:GetNext()
		end
	else
		local le={c:IsHasEffect(EFFECT_COMP_PAIRED)}
		for _,te in pairs(le) do
			local pr=te:GetLabelObject()
			if pr then pg:AddCard(pr) end 
		end			
	end
	return pg
end
function Card.GetPairCount(c)
	return c:GetPair():GetCount()
end
function cyan.prepaircancel(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local le={tc:IsHasEffect(EFFECT_PRE_PAIRED)}
		for _,te in pairs(le) do
			local pr=te:GetLabelObject()
			if pr and pr==c then te:Reset() end 
		end	
		tc=g:GetNext()
	end	
end
function cyan.paircomplete(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local le={tc:IsHasEffect(EFFECT_PRE_PAIRED)}
		for _,te in pairs(le) do
			local pr=te:GetLabelObject()
			if pr and pr==c then 
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				e0:SetCode(EFFECT_COMP_PAIRED)
				e0:SetReset(RESET_EVENT+RESETS_STANDARD)
				e0:SetLabelObject(c)
				tc:RegisterEffect(e0)
				c:SetCardTarget(tc)
				te:Reset()
				return true
			end
			
		end	
		tc=g:GetNext()
	end	
end
function cyan.pairingdesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local le={c:IsHasEffect(EFFECT_INDESTRUCTABLE_PAIR)}
		for _,te in pairs(le) do
			local pr=te:GetValue()
			if type(pr)=="function" then pr=pr(e) end
			if pr then
				return		
			end
		end		
	Duel.Destroy(e:GetHandler(),REASON_RULE+REASON_PAIR)
end
function cyan.pairingdescon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end
function cyan.pairdesop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetPair()
	if tc then Duel.Destroy(tc,REASON_RULE+REASON_PAIR) end
end
function cyan.pairdescheck(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0)
	local g=e:GetHandler():GetPair()
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
		if tc and eg:IsContains(tc) then e:SetLabel(1) end
		tc=g:GetNext()
	end
	
end
function cyan.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cyan.repfilter,1,nil,tp,e:GetHandler())
		and Duel.IsExistingMatchingCard(cyan.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,e:GetHandler()) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,cyan.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,e:GetHandler())
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function cyan.desfilter(c,tp,pc)
	return c:IsLocation(LOCATION_MZONE) and (c==pc or c:GetPair():IsContains(pc))
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function cyan.repfilter(c,tp,pc)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD) and (c:GetPair():IsContains(pc) or c==pc)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) or c:IsReason(REASON_REPLACE)) and not c:IsReason(REASON_PAIR)
end
function cyan.repval(e,c)
	return cyan.repfilter(c,e:GetHandlerPlayer(),e:GetHandler())
end
function cyan.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function Auxiliary.pairlimit(e,se,sp,st)
	return st&SUMMON_TYPE_PAIRING==SUMMON_TYPE_PAIRING
end



function Duel.CancelPair(c)
	if c:IsType(TYPE_PAIRING) then
		local c=c:GetPair()
	end
	if c:GetPair()~=nil then
		local le={c:IsHasEffect(EFFECT_COMP_PAIRED)}
		for _,te in pairs(le) do
			te:Reset()
		end	
	end
end
function Card.SetPair(c,pr)
	if c:IsType(TYPE_PAIRING) then
		if aux.GetValueType(pr)=="Group" then
			local tc=pr:GetFirst()
			while tc do
				if tc:IsType(TYPE_PAIRING) then
					cyan.SetPair2(c,tc)
					cyan.SetPair2(tc,c)
				else
					cyan.SetPair2(c,tc)
				end
				
				tc=pr:GetNext()
			end
		else
			cyan.SetPair2(c,pr)
		end
	else
		if aux.GetValueType(pr)=="Group" then
			Debug.Message("Card.SetPair : Parameter 2 Should Be \"Card\" when param 1 is not Pairing monster.")
			return 0
		else
			if not pr:IsType(TYPE_PAIRING) then
				Debug.Message("Card.SetPair : At least 1 parameter must be Pairing monster.")
			else
				cyan.SetPair2(pr,c)
			end
		end
	end
end
function cyan.SetPair2(c,prc)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_COMP_PAIRED)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	e0:SetLabelObject(c)
	prc:RegisterEffect(e0)
	c:SetCardTarget(prc)
end
--페어링 외 속성 삭제
local ty=Card.GetType
function Card.GetType(c)
	if bit.band(ty(c),TYPE_PAIRING)==TYPE_PAIRING then
		return bit.bor(ty(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ty(c)
end
local ity=Card.IsType
function Card.IsType(c,tp)
	if bit.band(ty(c),TYPE_PAIRING)==TYPE_PAIRING then
		if tp==TYPE_FUSION then return false end
		return ity(c,bit.bor(tp,TYPE_FUSION)-TYPE_FUSION)
	end	
	return ity(c,tp)
end