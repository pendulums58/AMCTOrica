--Cyan.lua_ver 2023/04/10_18:34


cyan=cyan or {}
Cyan=cyan
PI=50292967
FV=87902575

local dm=Debug.Message
RACE_SIXH=0x2000000
EFFECT_TYPE_ADMIN=0x8000
EFFECT_CHANGE_RECOVER=101237004
EFFECT_CYAN_ADDCODE=15881119	
EFFECT_ORIGINAL_CODE=15881120
EFFECT_DRAW_LIMIT=15881121
DRAW_COUNT=15881122
EFFECT_SELECTBY_OPPO=15881122
EFFECT_DESTROY_CANCEL=101223078
EFFECT_REMOVE_CANCEL=101223079
EFFECT_OPPO_FIELD_FUSION=101223080
EFFECT_LP_CANNOT_CHANGE=101223150
FLOWERHILL_THIMMUNE=103554020
EFFECT_PREVENT_NEGATION=101223182

global_deco_check=false

function Card.IsOwner(c,p)
	return c:GetOwner()==p
end
--Ŭ���̾�Ʈ ���Ŀ / SendtoHand ����
local dsth=Duel.SendtoHand
function Duel.SendtoHand(c,p,r)
	local g=Group.CreateGroup()
	if type(c)=="Card" then
		g:AddCard(c)
	else
		g:Merge(c)
	end
	--������ ���� ī�� �ɷ�����
	local g1=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	--�� �÷��̾�� �ش� ȿ���� ���������� ó��
	local spg=g1:Filter(Card.IsOwner,nil,0)
	local spg1=cyan.brokerprocess(spg,p)
	g:Merge(spg1)	
	local opg=g1:Filter(Card.IsOwner,nil,1)
	local opg1=cyan.brokerprocess(opg,p)
	g:Merge(opg1)

	if spg1:GetCount()>0 then
		Duel.ConfirmCards(1,spg1)
	end
	if opg1:GetCount()>0 then
		Duel.ConfirmCards(0,opg1)
	end
	return dsth(g,p,r)
end
function cyan.brokerprocess(g,p)
	--���� g�� ������ �״�� ����
	--���������� �߰��� ī��� g1�� �ȴ�
	local g1=Group.CreateGroup()
	if g:GetCount()==0 then return g1 end
	--g�� ������ �п� �־����� ī��, p�� �װ��� ������ �п� ����(nil�� ���� ����)
	local ow=g:GetFirst():GetOwner()
	if p==nil then p=ow end
	--���ΰ� �п� �ִ� �÷��̾ �ٸ��ٸ� �״�� ����
	if p~=ow then return g1 end
	--�ش� �÷��̾ ȿ���� �ް� �ִ����� üũ ��, ȿ���� ������ �� �ִ����� üũ.
	if Duel.IsPlayerAffectedByEffect(p,111310081) 
		and Duel.IsExistingMatchingCard(cyan.brokercheck,p,LOCATION_DECK,0,1,nil,g)
		and Duel.SelectYesNo(p,aux.Stringid(111310081,0)) then
		--ȿ���� ������� �� �ְ�, �׷��⸦ �����ߴٸ� ȿ�� ó��
		local th=Duel.SelectMatchingCard(p,cyan.brokercheck,p,LOCATION_DECK,0,1,1,nil,g)
		if th:GetCount()>0 then
			g1:Merge(th)
			--ó���ߴٸ�, �ش� �÷��̾�� ������ �ִ� ī�� �� �ϳ��� ���, ������ 1 �Ҹ��Ѵ�.
			local fg=Group.CreateGroup()
			for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(p,111310081)}) do
				fg:AddCard(pe:GetHandler())
			end
			local fc=nil
			if fg:GetCount()==1 then
				fc=fg:GetFirst()
			else
				fc=fg:Select(p,1,1,nil)
			end
			Duel.Hint(HINT_CARD,0,fc:GetCode())
			fc:RegisterFlagEffect(111310081,RESET_EVENT+RESETS_STANDARD,0,0)
		end
	end
	return g1
end
function cyan.brokercheck(c,g)
	return c:IsAbleToHand() and g:IsExists(cyan.brokercheck2,1,nil,c)	
end
function cyan.brokercheck2(c,tc)
	return c:IsLevel(tc:GetLevel()) and c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute()) and not c:IsCode(tc:GetCode())
end

function Card.IsCanBeFusionMaterialParareal(c)
	if c:IsStatus(STATUS_FORBIDDEN) then
		return false
	end
	if c:IsHasEffect(EFFECT_CANNOT_BE_FUSION_MATERIAL) then
		return false
	end
	if c:IsHasEffect(EFFECT_CANNOT_BE_MATERIAL) then
		return false
	end	
	-- if c:IsHasEffect(EFFECT_EXTRA_FUSION_MATERIAL) then
		-- local le={tc:IsHasEffect(EFFECT_EXTRA_FUSION_MATERIAL)}
		-- for _,te in pairs(le) do			
			-- local f1=te:GetValue()
			-- if type(f1)=="function" then f1=f1(te) end
			-- if f(te,tp) and val<f1 then
				-- val=f1
			-- end
		-- end		
	-- end
	return true
end


function Card.IsSetCardList(c,setcode)
	local set=tonumber(setcode)
	local code=0
	if not set then return false end
	while set>0 do
		code=math.floor(set%0x10000)
		if c:IsSetCard(code) then return true end
		set=math.floor(set/0x10000)
	end
	return false
end


-- local cisc=Card.IsSetCard
-- function Card.IsSetCard(c,sc)
	-- if not cisc(c,0xeff) then return cisc(c,sc) end
	-- local tp=c:GetControler()
	-- local g=Duel.GetMatchingGroup(cic,0,0xff,0xff,nil,cgc(c))
	-- local tc=g:GetFirst()
	-- while tc do
		-- if cisc(tc,sc) then return true end
		-- tc=g:GetNext()
	-- end
	-- return cisc(c,sc)
-- end
local dclc=Duel.CheckLPCost
function Duel.CheckLPCost(p,vl)
	if Duel.IsPlayerAffectedByEffect(p,101223030) then return dclc(p,vl*2) end
	return dclc(p,vl)
end
local dplc=Duel.PayLPCost
function Duel.PayLPCost(p,vl)
	if Duel.IsPlayerAffectedByEffect(p,101223030) then return dplc(p,vl*2) end
	return dplc(p,vl)	
end

function Card.IsInterDuoCode(c,hdl)
	dm("���� : ������ ���͵�� �ڵ带 ����ϰ� �ֽ��ϴ�.")
end


--���� ���� �Լ���
--�ݿ����� ����
function cyan.MAfilter(c)
	return (c:IsSetCard(0x60a) or c:IsSetCard(0x60b))
end
function Card.IsCreator(c)
	return c:IsSetCard(0x622) or c:IsSetCard(0x620) or c:IsSetCard(0xfe)
end

--ī�� ȿ�� �����ϴ� �Լ�
local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	--����ǡ��ĵ�
	if code==31677606 then
		e:SetCondition(cyan.bwcon)
	end

	if code==80896940 and mt.eff_ct[c][4]==e then
		e:SetCondition(cyan.nircon)
	end
	local et=e:GetType()
	if et&EFFECT_TYPE_XMATERIAL==EFFECT_TYPE_XMATERIAL then
		local egc=e:GetCondition()
		if type(egc)=="function" then e:SetCondition(cyan.etxmcon(egc)) 
		else
			e:SetCondition(cyan.etxmcon(egc))
		end
	end	
	--��޵���
	if code==94634433 and mt.eff_ct[c][0]==e then
        e:SetOperation(cyan.tuneop(e:GetOperation()))
    end
	if et&EFFECT_TYPE_ADMIN==EFFECT_TYPE_ADMIN then
		e:SetType(et-EFFECT_TYPE_ADMIN+EFFECT_TYPE_XMATERIAL)
		local egc=e:GetCondition()
		if type(egc)=="function" then e:SetCondition(cyan.etacon(egc)) 
		else
			e:SetCondition(cyan.etacon(egc))
		end
	end

end

function cyan.tuneop(op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsSSetable(true) and e:IsHasType(EFFECT_TYPE_ACTIVATE) 
			and Duel.IsPlayerAffectedByEffect(tp,101223218) and Duel.GetFlagEffect(tp,101223218)==0 then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			Duel.RegisterFlagEffect(tp,101223218,RESET_PHASE+PHASE_END,0,1)
		end	
	end
end
local dr=Duel.Recover
function Duel.Recover(tp,val,r)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local le={tc:IsHasEffect(EFFECT_CHANGE_RECOVER)}
		for _,te in pairs(le) do			
			local f=te:GetTarget()
			local f1=te:GetValue()
			if type(f1)=="function" then f1=f1(te) end
			if f(te,tp) and val<f1 then
				val=f1
			end
		end
		tc=g:GetNext()
	end
	dr(tp,val,r)
	return val
end
function cyan.etxmcon(egc)
	return
		function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			if type(egc)=="function" then
				return egc(e,tp,eg,ep,ev,re,r,rp) and not c:IsType(TYPE_ACCESS)
			else
				return not c:IsType(TYPE_ACCESS)
			end
		end
end
function cyan.etacon(egc)
	return
		function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			if type(egc)=="function" then
				return egc(e,tp,eg,ep,ev,re,r,rp) and c:IsType(TYPE_ACCESS)
			else
				return c:IsType(TYPE_ACCESS)
			end
		end
end
function cyan.bwcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c31677606.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		or Duel.IsPlayerAffectedByEffect(tp,101225018)
end

function cyan.addEastStyleEffect(c)
	local e=Effect.CreateEffect(c)
	e:SetCategory(CATEGORY_TOGRAVE)
	e:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e:SetProperty(EFFECT_FLAG_DELAY)
	-- e:SetCondition(cyan.esecon)
	e:SetCode(EVENT_REMOVE)
	e:SetTarget(cyan.esetg)
	e:SetOperation(cyan.eseop)
	c:RegisterEffect(e)
end
--������ū ȿ��
function cyan.SemiTokenAttribute(c)
	--������ ������ ��� �Ҹ�
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e:SetCode(EVENT_TO_GRAVE)
	e:SetOperation(cyan.semigraveop)
	c:RegisterEffect(e)
	local e1=e:Clone()
	e1:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e1)
end
function cyan.semigraveop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Exile(e:GetHandler(),REASON_RULE)
end
-- function cyan.esecon(e,tp,eg,ep,ev,re,r,rp)
	-- local c=e:GetHandler()
	-- return c:IsReason(REASON_EFFECT)
-- end
function cyan.esetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cyan.eseop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT+REASON_RETURN)
	end
end
function cyan.nirvanaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp=math.ceil(Duel.GetLP(1-tp)/2)
	Duel.SetLP(1-tp,lp)
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),101242002) then
		Duel.Recover(tp,lp,REASON_EFFECT)
	end
end
function cyan.nircon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetCondition() or (Duel.IsPlayerAffectedByEffect(c:GetControler(),101242009) and c:GetSummonType()==SUMMON_TYPE_PENDULUM)
end
local cit=Card.IsType
function Card.IsType(c,ty)
		if c:IsLocation(LOCATION_DECK) then
			local le={c:IsHasEffect(EFFECT_ADD_TYPE)}
			for _,te in pairs(le) do			
				local f1=te:GetValue()
				if type(f1)=="function" then f1=f1(te) end
				if bit.bor(ty,f1)==ty then 
				return true end
			end	
		end
		if c:IsCode(101253001) and c:IsLocation(LOCATION_OVERLAY) and bit.band(ty,TYPE_SYNCHRO)==TYPE_SYNCHRO then
			local tp=c:GetControler()
			local g=Duel.GetMatchingGroup(cit,0,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_XYZ)
			local tc=g:GetFirst()
			while tc do
				if tc:GetOverlayGroup():IsContains(c) and tc:GetOverlayCount()>1 then
					return true
				end
				tc=g:GetNext()
			end
			return false
		end
	return cit(c,ty)
end
local cgt=Card.GetType
function Card.GetType(c)

	local ty=cgt(c)
	if not c:IsLocation(LOCATION_DECK) then return ty end
	local mt=_G["c"..c:GetCode()]
	if mt and mt.eff_ct then
		if mt.eff_ct[c] and mt.eff_ct[c][0] then
			local tc=0
			while mt.eff_ct[c][tc] do
				local e=mt.eff_ct[c][tc]
				if e:GetCode()==EFFECT_ADD_TYPE and e:GetRange()==LOCATION_DECK then
					local f1=e:GetValue()
					if type(f1)=="function" then f1=f1(e) end
					ty=ty+f1
				end
				tc=tc+1
			end		
		end
	end 
	return ty	
end
-- function Card.GetType(c)
	-- local ty=cgt(c)
		-- local le={c:IsHasEffect(EFFECT_ADD_TYPE)}
		-- for _,te in pairs(le) do	
			-- local f1=te:GetValue()
			-- if type(f1)=="function" then f1=f1(te) end
			-- if c:IsLocation(te:GetRange()) then 
				-- ty=ty+f1 
				-- Debug.Message("ok")
			-- end
			-- Debug.Message("loc="..c:GetLocation()..", ran="..te:GetRange())
			-- ty=ty+f1
		-- end	
		-- Debug.Message("code"..c:GetCode()..", ty="..ty)
	-- return ty	
-- end
local cgc=Card.GetCode
function Card.GetCode(c)
	if cgc(c)==111310098 then return 111310014 end
	return cgc(c)
end

local cgoc=Card.GetOriginalCode
function Card.GetOriginalCode(c)
	if cgoc(c)==111310098 then return 111310014 end
	return cgoc(c)
end

local cic=Card.IsCode
function Card.IsCode(c,...)
	local code={...}
	if cgc(c)==111310098 then
		for i=1,#code do
			if code[i]==111310014 then
				return true
			end
		end
	end
	return cic(c,...)
end

local cioc=Card.IsOriginalCode
function Card.IsOriginalCode(c,...)
	local code={...}
	if cgoc(c)==111310098 then
		for i=1,#code do
			if code[i]==111310014 then
				return true
			end
		end
	end
	return cioc(c,...)
end
-- ��ο� �ż� ���� ȿ�� (�帷�� ������ ��, ������)
-- �ش� �÷��̾ �� �Ͽ� ��ο��� �� �ִ� �ż��� ������ �����Ѵ�.
-- �̴� �Ϲ� ��ο쵵 �����Ѵ�. �Ϲ� ��ο��� �ż��� �ٲٴ� ȿ������ �����ؾ� �� (EFFECT_DRAW_COUNT)

local rege=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	--��� ��ο� ���� ȿ���� ����.
	if e:GetCode()==EFFECT_DRAW_COUNT then 
		local val=e:GetValue()
		if val then e:SetValue(cyan.dcval(val)) end
	end
	rege(c,e,forced,...)
	
end

function cyan.dcval(val)
	return function(e)
		local tp=e:GetHandlerPlayer()
		local ct=0
		if type(val)=="function" then ct=val(e)
		else ct=val
		end
		
		for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_DRAW_LIMIT)}) do
			if ct>pe:GetValue() then ct=pe:GetValue() end
		end		
		return ct
	end
end



local ddr=Duel.Draw
function Duel.Draw(p,ct,r)
	--�ش� �÷��̾ ��ο� ���� ȿ���� �ް� ������, �� �Ͽ� �ش� �÷��̾ ��ο��� �ż��� üũ
	--ȿ���� ��ο��ϴ� ��쿡�� Duel.Draw ��ü�� ��ο��� �ż���ŭ�� RegisterFlagEffect�� ���̰�, �Ϲ� ��ο��� ����... ��¼��
	--EFFECT_DRAW_COUNT�� Clone���� SetReset�� ���� ������ �Ϲݵ�ο쿡 Ʈ���� Ƣ�� �ұ�? �̰� �ǳ� -> �̰ɷ� �غ���
	--�̰� �´°Ű�����? DRAW_COUNT�� Ƣ���ؼ� ��ο������� DRAW_COUNT�� flag�� ��ο� ���ڷ� Ƣ�� ����.
	--�׷��� ����� �ż� ��ο������� �� ���ڸ�ŭ lim���� ����, flag�� ��Ƣ�������� ����ϰ� ��ο��ѰŴϱ� 1�� ����
	--��ο������� ��ŵ�� �װſ� ���� reset���� ����ھƼ� �÷��� ����. ȥ�� �÷��׸� ��Դ°ž� �̰�
	local lim=99
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_DRAW_LIMIT)}) do
		if lim>pe:GetValue() then lim=pe:GetValue() end
	end
	--������� �ش� �÷��̾ �ް� �ִ� ��ο� �ż� ���� �� ���� ���� ��ġ ����(lim). �� lim��ġ���� ���� ��ο�� �� �Ͽ� �� �� ����.
	local alr=Duel.GetFlagEffect(p,DRAW_COUNT)
	--alr�� �ش� �÷��̾ �� �Ͽ� ��ο��� �ż�. lim-alr�� ���� ���� ���� ��ο� ��.
	local can=lim-alr
	if ct>can then ct=can end
	local cct=ddr(p,ct,r)
	--cct�� ���� ��ο�� �ż�. �� ���ڸ�ŭ ����Ʈ���� �Ҹ��� ����
	Duel.RegisterFlagEffect(p,DRAW_COUNT,RESET_PHASE+PHASE_END,0,cct+alr)
	return cct
end

-- ȿ�� ��ȿ�κ��� ��ȣ(��?�� �����̾�)
-- ȿ�� ��ȿ (NegateActivation / NegateEffect ����)�� �����Ͽ� �ش� ȿ�� ��ȿ�� ó������ ���� �� CountLimit �Ҹ�


local dna=Duel.NegateActivation
function Duel.NegateActivation(v)
	local te=Duel.GetChainInfo(v,CHAININFO_TRIGGERING_EFFECT)
	local p=te:GetHandlerPlayer()
	local protect=false
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_PREVENT_NEGATION)}) do
		if not protect then
			protect=true
			pe:UseCountLimit(p,1)
		end
	end
	
	if protect then
		local dummy=Duel.SelectOption(p,aux.Stringid(101223182,0))
		local dummy=Duel.SelectOption(1-p,aux.Stringid(101223182,1))
		return 0
	else
		return dna(v)
	end
end

local dne=Duel.NegateEffect
function Duel.NegateEffect(v)
	local te=Duel.GetChainInfo(v,CHAININFO_TRIGGERING_EFFECT)
	local p=te:GetHandlerPlayer()
	local protect=false
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_PREVENT_NEGATION)}) do
		if not protect then
			protect=true
			pe:UseCountLimit(p,1)
		end
	end
	
	if protect then
		local dummy=Duel.SelectOption(p,aux.Stringid(101223182,0))
		local dummy=Duel.SelectOption(1-p,aux.Stringid(101223182,1))
		return 0
	else
		return dne(v)
	end
end




-- ��� ���� ȿ�� (��밡 ���� / ������� �ϴ� ȿ���� ���ñ��� �ڽ��� ������)
-- �ش��ϴ� �Լ����� Select ���� ����(SelectMatchingCard / SelectSubGroup / GetMatchingGroup + Group ������ Select �Լ� ����)
-- �ش� �÷��̾ ȿ���� �ް� ������, �ش� �÷��̾��� ���� ���� ȿ���� �� �ݴ� �÷��̾ �˿��� (tp���� ����ǰ� ������ tp�� ����ϴ� ������ ������ ����)
-- �ش� �Լ����� �Ű����� �� tp�� LOCATION�� �Է¹޾��� ��, LOCATION_DECK ������ LOCATION_GRAVE�� ���ԵǾ� ������ 1�� �Ű�����(������)�� �����´�
-- �Լ� ���
-- Duel.SelectMatchingCard(������,����,����,�ڽ���ġ,�����ġ,�ּҸż�,�ִ�ż�,����)
-- Duel.SelectTarget(������,����,����,�ڽ���ġ,�����ġ,�ּҸż�,�ִ�ż�,����) -> ������ ������������� ������ ��ǻ� ���� ����
-- Duel.SelectFusionMaterial(������,)
-- �ϴ� �����Ѱ͸� �ص���
local dsmc=Duel.SelectMatchingCard
function Duel.SelectMatchingCard(sel,fil,pos,sloc,oloc,min,max,...)
	--������(sel)�� �ڽ��� ���� Ȯ���ϴ� ��쿡 ����Ǿ�� ��. sel==pos�̰� sloc�̰ų� sel!=pos�̰� oloc�̾�� ��.
	if sel==pos and bit.band(sloc,LOCATION_DECK)==LOCATION_DECK then
		if Duel.IsPlayerAffectedByEffect(sel,EFFECT_SELECTBY_OPPO) then 
			sel=1-sel 
			local g=Duel.GetMatchingGroup(fil,pos,sloc,oloc,...)
			Duel.ConfirmCards(sel,g)
		end
	end
	if not sel==pos and bit.band(oloc,LOCATION_DECK)==LOCATION_DECK then
		if Duel.IsPlayerAffectedByEffect(sel,EFFECT_SELECTBY_OPPO) then 
			sel=1-sel 
			local g=GetMatchingGroup(fil,pos,sloc,oloc,...)
			Duel.ConfirmCards(sel,g)
		end
	end
	return dsmc(sel,fil,pos,sloc,oloc,min,max,...)
end
local gsl=Group.Select
function Group.Select(g,sel,m,x,els)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) and Duel.IsPlayerAffectedByEffect(sel,EFFECT_SELECTBY_OPPO) then
		sel=1-sel 
		Duel.ConfirmCards(sel,g)
	end
	return gsl(g,sel,m,x,els)
end
local ssg=aux.SelectUnselectGroup
function Auxiliary.SelectUnselectGroup(g,e,tp,minc,maxc,rescon,chk,seltp,hintmsg,finishcon,breakcon,cancelable)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) and Duel.IsPlayerAffectedByEffect(seltp,EFFECT_SELECTBY_OPPO) then
		seltp=1-seltp 
		Duel.ConfirmCards(seltp,g)
	end
	
	return ssg(g,e,tp,minc,maxc,rescon,chk,seltp,hintmsg,finishcon,breakcon,cancelable)	
end

function Card.IsPreviousControler(c,p)
	local tp=c:GetPreviousControler()
	if tp==p then return true end
	return false
end




cyan.PlayerCounter={
--�÷��̾� ī���� ���
--ī����(����� ����)
[0x1]={0,0},
--��ȭ���� ����
[0x2]={0,0},
}

function Duel.AddPlayerCounter(p,code,ct)
	if not cyan.PlayerCounter[code] then
		Debug.Message("Duel.AddPlayerCounter : Invaild pcounter code.")
		return 0
	else
		cyan.PlayerCounter[code][p+1]=cyan.PlayerCounter[code][p+1]+ct
		return ct
	end
end
function Duel.GetPlayerCounter(p,code)
	if not cyan.PlayerCounter[code] then
		Debug.Message("Duel.GetPlayerCounter : Invaild pcounter code.")
		return 0
	else
		return cyan.PlayerCounter[code][p+1]
	end	
end
function Duel.RemovePlayerCounter(p,code,ct)
	if not cyan.PlayerCounter[code] then
		Debug.Message("Duel.RemovePlayerCounter : Invaild pcounter code.")
		return 0
	else
		if cyan.PlayerCounter[code][p+1]<ct then ct=cyan.PlayerCounter[code][p+1] end
		cyan.PlayerCounter[code][p+1]=cyan.PlayerCounter[code][p+1]-ct
		return ct
	end	
end
function Duel.SetPlayerCounter(p,code,ct)
	if not cyan.PlayerCounter[code] then
		Debug.Message("Duel.RemovePlayerCounter : Invaild pcounter code.")
		return 0
	else
		cyan.PlayerCounter[code][p+1]=ct
		return ct
	end	
end
cyan.CheckTargetRange={0,0}
local estr=Effect.SetTargetRange
function Effect.SetTargetRange(e,s,o)
	cyan.CheckTargetRange={s,o}
	estr(e,s,o)
end

local dregeff=Duel.RegisterEffect
function Duel.RegisterEffect(e,p)
	if bit.band(e:GetProperty(),EFFECT_FLAG_PLAYER_TARGET)==EFFECT_FLAG_PLAYER_TARGET then
		if cyan.CheckTargetRange[1]==1 and cyan.CheckTargetRange[2]==0 and Duel.GetPlayerCounter(p,0x1)>0
			and Duel.SelectYesNo(p,683,Duel.GetPlayerCounter(p,0x1)) then
			e:SetTargetRange(0,1)
			Duel.RemovePlayerCounter(p,0x1,1)
		end
		if cyan.CheckTargetRange[1]==0 and cyan.CheckTargetRange[2]==1 and Duel.GetPlayerCounter(1-p,0x1)>0
			and Duel.SelectYesNo(1-p,683,Duel.GetPlayerCounter(p,0x1)) then
			e:SetTargetRange(1,0)
			Duel.RemovePlayerCounter(1-p,0x1,1)
		end		
		local s=cyan.CheckTargetRange[1]
		local o=cyan.CheckTargetRange[2]
		--�ö������ �п����������� �ο� ��ȿȭ(���� �ö���� ��ƿ�� ��������� �̵�)	
		local ecode=e:GetCode()
		if ecode==EFFECT_CANNOT_TO_HAND or ecode==EFFECT_CANNOT_DRAW then
			if Duel.IsPlayerAffectedByEffect(p,FLOWERHILL_THIMMUNE) 
				and cyan.CheckTargetRange[1]==1 then 
				s=0
			end
			if Duel.IsPlayerAffectedByEffect(1-p,FLOWERHILL_THIMMUNE) 
				and cyan.CheckTargetRange[2]==1 then 
				o=0
			end	
			e:SetTargetRange(s,o)
		end
	end
	dregeff(e,p)
end

local dds=Duel.Destroy
function Duel.Destroy(g,r)
	if type(g)=="Card" then
		local tc=g
		g=Group.CreateGroup()
		g:AddCard(tc)
	end
	if Duel.IsPlayerAffectedByEffect(0,EFFECT_DESTROY_CANCEL) then
		local og=g:Filter(Card.IsControler,nil,0)
		g:Sub(og)
	end
	if Duel.IsPlayerAffectedByEffect(1,EFFECT_DESTROY_CANCEL) then
		local sg=g:Filter(Card.IsControler,nil,1)
		g:Sub(sg)
	end
	return dds(g,r)
end

local drm=Duel.Remove
function Duel.Remove(g,pos,r)
	if type(g)=="Card" then
		local tc=g
		g=Group.CreateGroup()
		g:AddCard(tc)
	end
	if Duel.IsPlayerAffectedByEffect(0,EFFECT_REMOVE_CANCEL) then
		local og=g:Filter(Card.IsControler,nil,0)
		g:Sub(og)
	end
	if Duel.IsPlayerAffectedByEffect(1,EFFECT_REMOVE_CANCEL) then
		local sg=g:Filter(Card.IsControler,nil,1)
		g:Sub(sg)
	end
	return drm(g,pos,r)
end

local dss=Duel.SpecialSummon
function Duel.SpecialSummon(c,st,sp,fp,tf,tf1,...)
	if type(c)=="Card" then
		if c:IsHasEffect(EFFECT_OPPO_FIELD_FUSION) and st==SUMMON_TYPE_FUSION then
			if sp==c:GetControler() then
				fp=1-sp
			end
		end	
	end
	if type(c)=="Group" then
		local tc=c:GetFirst()
		local g=Group.CreateGroup()
		while tc do
			if tc:IsHasEffect(EFFECT_OPPO_FIELD_FUSION) and st==SUMMON_TYPE_FUSION then
				if sp==tc:GetHandler():GetControler() then
					fp=1-sp
					g:AddCard(tc)
					c:RemoveCard(tc)
				end
			end	
			tc=c:GetNext()
		end
	end
	if g and g:GetCount()>0 then
		dss(g,st,sp,fp,tf,tf1,...)
	end
	return dss(c,st,sp,fp,tf,tf1,...)
end

local dcc=Duel.ConfirmCards
function Duel.ConfirmCards(p,g)
	if type(g)=="number" then
		return dcc(g,p)
	end
	return dcc(p,g)
end

--����
function Duel.Scry(e,p,ct)
	if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)<ct then return false end
	local g=Duel.GetDecktopGroup(p,ct)
	Duel.ConfirmCards(p,g)
	if Duel.SelectYesNo(p,683) then
		if g:GetCount()>1 then
			local g1=g:Select(p,1,ct)
			g:Sub(g1)
			while g:GetCount()>0 do
				local g2=g:Select(p,1,1)
				Duel.MoveSequence(g2:GetFirst(),1)
				g:Sub(g2)
			end
			Duel.SortDecktop(p,p,g1:GetCount())
		else
			
		end
	else
		Duel.SortDecktop(p,p,ct)
		for i=1,ct do
			local tg=Duel.GetDecktopGroup(p,1)
			Duel.MoveSequence(tg:GetFirst(),1)
		end
	end
end
function Duel.IsPlayerCanScry(p,ct)
	return Duel.GetFieldGroupCount(p,LOCATION_DECK,0)>=ct
end

yusha_token_codes={3285553,3285554,3285555,3285556,3285557,3285558,3285559,3285560,3285561,3285562,3285563,3285564,3285565,3285566,3285567,3285568}
local dct=Duel.CreateToken
function Duel.CreateToken(p,code)
	if code==3285552 then
		code=yusha_token_codes[Duel.GetRandomNumber(1,#yusha_token_codes)]
	end
	return dct(p,code)
end


function Card.AddStoryTellerAttribute(c,tc)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_MONSTER+TYPE_EFFECT)
	e1:SetReset(RESET_EVENT+0x47c0000)
	c:RegisterEffect(e1,true)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e3,true)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetValue(500)
	c:RegisterEffect(e4,true)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_SET_BASE_DEFENSE)
	e5:SetValue(500)
	c:RegisterEffect(e5,true)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CHANGE_RACE)
	e6:SetValue(RACE_FAIRY)
	c:RegisterEffect(e6,true)
	local e7=e1:Clone()
	e7:SetCode(EFFECT_CHANGE_LEVEL)
	e7:SetValue(3)
	c:RegisterEffect(e7,true)	
end

Debug.Message("Cyan.lua Version 23/04/10 loaded.")
pcall(dofile,"repositories/OricaPack/script/orica_constant.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_utility.lua")
pcall(dofile,"repositories/OricaPack/script/key_system.lua")
--pcall(dofile,"repositories/OricaPack/script/proc_xyz_additional.lua")
-- pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/interduo.lua")
pcall(dofile,"repositories/OricaPack/script/proc_access.lua")
pcall(dofile,"repositories/OricaPack/script/proc_pairing.lua")
pcall(dofile,"repositories/OricaPack/script/bossraid_battle.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/clocktower.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/starsnow.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/nightmist.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/libertylane.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/raimei.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/draco.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/fragmata.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/celestia.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/diletant.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/companion.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/saintmirage.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/amass.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/furioso.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/sakura.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/emberfox.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/unity.lua")
pcall(dofile,"repositories/OricaPack/script/cyan_themeutils/radiant.lua")