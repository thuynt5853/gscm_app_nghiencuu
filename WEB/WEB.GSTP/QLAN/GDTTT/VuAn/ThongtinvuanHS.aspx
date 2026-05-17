<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThongtinvuanHS.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.ThongtinvuanHS" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddGUID" runat="server" Value="" />
    <asp:HiddenField ID="hddNext" runat="server" Value="0" />
    <asp:HiddenField ID="hddIsAnPT" runat="server" Value="PT" />
    <asp:HiddenField ID="hddInputAnST" runat="server" Value="0" />
    <style>
        .clear_bottom {
            margin-bottom: 0px;
        }

        .button_empty {
            border: 1px solid red;
            border-radius: 4px;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
            color: #044271;
            background: white;
            float: right;
            font-size: 12px;
            font-weight: bold;
            line-height: 23px;
            padding: 0px 5px;
            margin-left: 3px;
            margin-bottom: 8px;
            text-decoration: none;
        }

        .tableva {
            /*border: solid 1px #dcdcdc;width: 100%;*/
            border-collapse: collapse;
            margin: 5px 0;
        }

            .tableva td {
                padding: 2px;
                padding-left: 2px;
                padding-left: 5px;
                vertical-align: middle;
            }
        /*-------------------------------------*/
        .table_list {
            border: solid 1px #dcdcdc;
            border-collapse: collapse;
            margin: 5px 0;
            width: 100%;
        }


            .table_list .header {
                background: #db212d;
                border: solid 1px #dcdcdc;
                padding: 2px;
                font-weight: bold;
                height: 30px;
                color: #ffffff;
            }

            .table_list header td {
                background: #db212d;
                border: solid 1px #dcdcdc;
                padding: 2px;
            }

            .table_list td {
                border: solid 1px #dcdcdc;
                padding: 5px;
                line-height: 17px;
                vertical-align: top;
            }

        .ajax__calendar_container {
            width: 220px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 140px;
        }

        .title_ds {
            float: left;
            width: 100%;
            font-weight: bold;
            margin: 5px 0px;
        }

        .listbc {
            float: left;
            width: 100%;
            margin: 3px 0px;
        }

        .listbc_item {
            float: left;
            width: 100%;
            border-bottom: dotted 1px #dcdcdc;
            margin-bottom: 5px;
            padding-bottom: 3px;
        }

            .listbc_item:last-child {
                border-bottom: none;
            }

        .col_tenbc {
            width: 150px;
        }

        .col_toidanh {
            width: 80px;
        }

        .loaibc {
            margin-left: 5px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                  <%--  <asp:Button ID="cmdUpdateAndNew" runat="server"
                        OnClientClick="return validate();"
                        CssClass="buttoninput" Text="Lưu & Thêm mới" OnClick="cmdUpdateAndNew_Click" />--%>
                    <asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLamMoi_Click" />
                    <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput"
                        Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>
                <div style="margin: 5px; width: 95%; color: red;">
                    <asp:Label ID="lttMsgT" runat="server"></asp:Label>
                </div>
                <div class="boxchung">

                    <div style="float: left; margin-top: 8px; width: 100%;">
                        <h4 class="tleboxchung">Thông tin bản án</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="tableva">
                                <tr>
                                    <td style="width: 120px;">Hình thức <span class="batbuoc">*</span></td>
                                    <td style="width: 255px;">
                                        <asp:DropDownList ID="dropLoaiGDT" CssClass="chosen-select" OnSelectedIndexChanged="dropLoaiGDT_SelectedIndexChanged"
                                            AutoPostBack="true" runat="server" Width="250px">
                                            <asp:ListItem Value="0" Text="Đơn đề nghị GĐT,TT"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Rút Hồ sơ đoàn kiểm tra"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Chủ động GĐT qua Bản án"></asp:ListItem>
                                            <%--<asp:ListItem Value="1" Text="Kháng nghị của VKS"></asp:ListItem>--%>
                                        </asp:DropDownList>
                                        <!--Dung trường TRUONGHOPTHULY de phan biet-->
                                    </td>

                                    <td>Thủ tục giải quyết</td>
                                    <td>
                                        <asp:DropDownList ID="ddl_LOAI_GDTTT" Width="250px" CssClass="chosen-select" runat="server">
                                            <asp:ListItem Value="0" Text="--chọn--" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Giám đốc thẩm"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Tái thẩm"></asp:ListItem>
                                            <%--<asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>--%>
                                        </asp:DropDownList>
                                    </td>
                                   
                                </tr>
                                <tr>
                                    <td style="width: 120px;">Cấp Xét xử</td>
                                    <td style="width: 255px;">
                                        <asp:DropDownList ID="ddlLoaiBA" CssClass="chosen-select"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiBA_SelectedIndexChanged"
                                            runat="server" Width="250px">
                                            <asp:ListItem Value="3" Text="Phúc thẩm" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Sơ thẩm"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="QĐ GĐT"></asp:ListItem>
                                        </asp:DropDownList>

                                    </td>

                                    <td style="width: 95px;">Loại án</td>
                                    <td style="width: 255px;">
                                        <asp:DropDownList ID="dropLoaiAn" runat="server"
                                            Width="250px" CssClass="chosen-select">
                                        </asp:DropDownList>
                                    </td>

                                </tr>
                                <!---------------QĐ GDT----------------------------->
                                <asp:Panel ID="pnQDGDT" runat="server" Visible="false">
                                    <tr>
                                        <td style="width: 120px;">Số QĐ GĐT
                                    <asp:Literal ID="ltt_SoGDT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                        </td>
                                        <td style="width: 255px;">
                                            <asp:TextBox ID="txtSoQĐGDT" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>

                                        <td style="width: 95px;">Ngày QĐ GĐT<asp:Literal ID="ltt_NgayGDT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayGDT" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender12" runat="server" TargetControlID="txtNgayGDT" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender12" runat="server" TargetControlID="txtNgayGDT"
                                                Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tòa án ra QĐ GDT<asp:Literal ID="ltt_ToaGDT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td>
                                            <asp:DropDownList ID="dropToaGDT" CssClass="chosen-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropToaGDT_SelectedIndexChanged"
                                                runat="server" Width="250px">
                                            </asp:DropDownList>
                                        </td>
                                        <td colspan="2">
                                            </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" style="border-bottom: 1.5px dotted #808080;"></td>
                                    </tr>
                                </asp:Panel>
                                <!---------------An PT----------------------------->
                                <asp:Panel ID="pnPhucTham" runat="server">
                                    <tr>
                                        <td style="width: 120px;">Số BA Phúc thẩm
                                    <asp:Literal ID="lttBB_SoPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                        </td>
                                        <td style="width: 255px;">
                                            <asp:TextBox ID="txtSoBA" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                        <td style="width: 95px;">Ngày BA Phúc thẩm
                                            <asp:Literal ID="lttBB_NgayPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayBA" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayBA" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayBA"
                                                Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tòa án xét xử PT
                                            <asp:Literal ID="lttBB_ToaPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td>
                                            <asp:DropDownList ID="dropToaAn" CssClass="chosen-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropToaAn_SelectedIndexChanged"
                                                runat="server" Width="250px">
                                            </asp:DropDownList>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" style="border-bottom: 1.5px dotted #808080;"></td>
                                    </tr>
                                </asp:Panel>
                                <!-----------An ST--------------------------------->
                                <asp:Panel ID="pnAnST" runat="server">
                                    <tr>
                                        <td>Số BA/QĐ Sơ thẩm
                                <asp:Literal ID="lttBB_SoST" runat="server" Visible="false" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td>
                                            <asp:TextBox ID="txtSoBA_ST" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                        <td>Ngày BA/QĐ Sơ thẩm
                                <asp:Literal ID="lttBB_NgayST" runat="server" Visible="false" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayBA_ST" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtNgayBA_ST" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtNgayBA_ST"
                                                Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tòa án xét xử sơ thẩm
                                <asp:Literal ID="lttBB_ToaST" runat="server" Visible="false" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td>
                                            <asp:DropDownList ID="dropToaAnST" CssClass="chosen-select"
                                                runat="server" Width="250px">
                                            </asp:DropDownList>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </asp:Panel>
                                <%-- Dieu luat ap dung --%>
                                <tr>
                                    <td style="width: 120px;">Điều luật áp dụng thống kê<span class="batbuoc">*</span></td>
                                    <td style="width: 255px;" colspan ="3">
                                                <asp:DropDownList ID="dropDieuLuat" runat="server"
                                                    CssClass="chosen-select" Width="610px">
                                                </asp:DropDownList>
                                    </td>
                                    
                                </tr>
                            </table>
                        </div>
                    </div>
                    <!---------------------------->
                    <div style="float: left; margin-top: 8px; width: 100%;">
                        <h4 class="tleboxchung">Danh sách Bị cáo</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td>
                                        <div style="color: red; font-size: 15px; text-align: center;">
                                            <asp:Literal ID="lttMsgBC" runat="server"></asp:Literal>
                                        </div>
                                    </td>
                                </tr>
                               
                                <tr>
                                    <td style="color: red; font-size: 15px; text-align: left;">
                                             <asp:LinkButton ID="lkThem_BC" runat="server" OnClick="lkThemBiCao_Click"
                                                CssClass="button_empty" ToolTip="Quản lý bị cáo">Bị cáo</asp:LinkButton>
                                             <div style="display: none;">
                                                <asp:Button ID="cmd_loadbc" runat="server" CssClass="buttoninput" Text="Load bi cao" OnClick="cmd_loadbc_Click" />
                                            </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table class="table2" width="100%" border="1">
                                            <tr class="header">
                                                <td width="42">
                                                    <div align="center"><strong>TT</strong></div>
                                                </td>
                                                <td width="250px">
                                                    <div align="center"><strong>Họ tên</strong></div>
                                                </td>
                                                <td>
                                                    <div align="center"><strong>Thông tin Bị cáo, Tội danh, mức án</strong></div>
                                                </td>
                                                <td width="100px">
                                                    <div align="center"><strong>Thao tác</strong></div>
                                                </td>
                                            </tr>
                                            <asp:Repeater ID="rptBiCao" runat="server"
                                                OnItemDataBound="rptBiCao_ItemDataBound"
                                                OnItemCommand="rptBiCao_ItemCommand">
                                                <ItemTemplate>
                                                    <tr>
                                                        <td>
                                                            <div align="center"><%# Container.ItemIndex + 1 %></div>
                                                        </td>
                                                        <td>
                                                            <asp:Literal ID="lttTenDS" runat="server"></asp:Literal>
                                                        </td>
                                                        <td runat="server">
                                                            <asp:Literal ID="lttToidanh" runat="server"></asp:Literal>
                                                        </td>
                                                        <td>
                                                            <div id="td_sua_div" runat="server" align="center" style="width: 100px;">
                                                                <div style="float: left; margin-left: 15px;">
                                                                    <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                                                        Text="Xóa" ForeColor="#0e7eee"
                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa Bị cáo này? ');"></asp:LinkButton>
                                                                </div>
                                                                <br/>
                                                                <div style="margin-top: 3px;">
                                                                    <asp:Literal ID="ltt_them_td" runat="server"></asp:Literal>
                                                                </div>
                                                                <div style="display: none;">
                                                                    <asp:LinkButton ID="lbtthem_td" runat="server" CausesValidation="false"
                                                                        Text="Thêm tội danh" ForeColor="#0e7eee"
                                                                        CommandName="them_td" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                               
                                        </table>
                                    </td>
                                </tr>

                                 

                            </table>
                        </div>
                    </div>
                     <!---------------------------->
                     <div style="float: left; margin-top: 8px; width: 100%;">
                        <h4 class="tleboxchung">Thông tin khiếu nại</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td style="color: red; font-size: 15px; text-align: left;">
                                        <%--<div style="color: red; font-size: 15px; text-align: left;">--%>
                                             <asp:LinkButton ID="lbtThemNguoiKN" runat="server" OnClick="lkThemNguoiKN_Click"
                                                CssClass="button_empty" ToolTip="Quản lý Người khiếu nại">Người khiếu nại</asp:LinkButton>
                                        <%--</div>--%>
                                            <div style="display: none;">
                                                <asp:Button ID="cmd_loadkn" runat="server" CssClass="buttoninput" Text="Làm mới"
                                                    OnClick="cmd_loadkn_Click" />
                                            </div>
                                        
                                    </td>
                                </tr>
                               
                                <tr>
                                    <td>
                                        <table class="table2" width="100%" border="1">
                                            <tr class="header">
                                                <td width="42">
                                                    <div align="center"><strong>TT</strong></div>
                                                </td>
                                                <td width="250px">
                                                    <div align="center"><strong>Họ tên người khiếu nại</strong></div>
                                                </td>
                                                <td>
                                                    <div align="center"><strong>Thông tin Bị cáo được khiếu nại</strong></div>
                                                </td>
                                                <td width="100px">
                                                    <div align="center"><strong>Thao tác</strong></div>
                                                </td>
                                            </tr>
                                            <asp:Repeater ID="rptNguoiKN" runat="server"
                                                OnItemDataBound="rptNguoiKN_ItemDataBound"
                                                OnItemCommand="rptNguoiKN_ItemCommand">
                                                <ItemTemplate>
                                                    <tr>
                                                        <td>
                                                            <div align="center"><%# Container.ItemIndex + 1 %></div>
                                                        </td>
                                                        <td>
                                                            <asp:Literal ID="lttTenDS" runat="server"></asp:Literal>

                                                        </td>
                                                        <td runat="server">
                                                            <asp:Literal ID="lttNguoiKN" runat="server"></asp:Literal>
                                                            <asp:Repeater ID="rptBCKN" runat="server" OnItemCommand="RptBCKN_ItemCommand">
                                                                <HeaderTemplate>
                                                                    <div class="listbc">
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <div class="listbc_item" style="position: relative;">
                                                                        <div style="float: left; width: 30%; font-weight: bold;">
                                                                            <%# Container.ItemIndex + 1 %><%# ". "
                                                                              + Eval("BiCao_TuCachTT")
                                                                              + " "+ (String.IsNullOrEmpty(Eval("BiCaoName")+"")?"Khác":Eval("BiCaoName")+"") %>
                                                                        </div>
                                                                        <div style="float: left; margin-left: 1%; width: 58%;">
                                                                            <%#String.IsNullOrEmpty(Eval("Hs_MucAn") +"")?"":("Mức án:"+Eval("Hs_MucAn")+"") %>

                                                                            <div style="float: left; width: 100%;">
                                                                                <%#String.IsNullOrEmpty(Eval("ListToiDanhBC") +"")?"":("Tội danh:"+Eval("ListToiDanhBC")+"") %>
                                                                            </div>
                                                                            <div style="float: left; width: 100%;">
                                                                                <%#String.IsNullOrEmpty(Eval("NoiDungKhieuNai") +"")?"":("Khiếu nại: "+Eval("NoiDungKhieuNai")) %>
                                                                            </div>
                                                                        </div>
                                                                        <div style="position: absolute; right: -76px; width: 100px; text-align: center; margin-top: 10px;">                                                                            
                                                                             <asp:LinkButton ID="lbtXoaKN" runat="server" CausesValidation="false"
                                                                                 Text="Xóa" ForeColor="#0e7eee"
                                                                                 CommandName="XoaKN" CommandArgument='<%#Eval("ID") %>'
                                                                                 OnClientClick="return confirm('Bạn thực sự muốn xóa khiếu nại cho bị cáo này? ');"></asp:LinkButton>
                                                                        </div>
                                                                    </div>
                                                                </ItemTemplate>
                                                                <FooterTemplate></div></FooterTemplate>
                                                            </asp:Repeater>
                                                        </td>
                                                        <td>
                                                            <div id="td_sua_div" runat="server" align="center" style="width: 69px;">
                                                                <asp:LinkButton ID="lbtXoaKN" runat="server" CausesValidation="false"
                                                                    Text="Xóa" ForeColor="#0e7eee"
                                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa Thông tin khiếu nại này? ');"></asp:LinkButton>
                                                               
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                               
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <!---------------------------->

                    <asp:Panel ID="pnThuLyDon" runat="server" Style="display: none;">
                        <div style="float: left; margin-top: 8px; width: 100%;">
                            <h4 class="tleboxchung">Thông tin thụ lý đơn đề nghị GĐT,TT</h4>
                            <div class="boder" style="padding: 10px;">
                                <table class="tableva">
                                    <tr>
                                        <td style="width: 120px;">Số thụ lý<span class="batbuoc"></span></td>
                                        <td style="width: 255px;">
                                            <asp:TextBox ID="txtSoThuLy" CssClass="user" runat="server"
                                                Width="242px"></asp:TextBox>
                                        </td>
                                        <td style="width: 95px;">Ngày thụ lý<span class="batbuoc"></span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayThuLy" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayThuLy" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayThuLy" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Ngày ghi trên đơn/Ngày gửi đơn</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayTrongDon" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayTrongDon" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayTrongDon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Ngày nhận đơn</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayNhanDon" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayNhanDon" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayNhanDon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>

                                </table>
                            </div>
                        </div>
                    </asp:Panel>
                    <!---------------------------->
                    <div style="float: left; margin-top: 8px; width: 100%;">
                        <h4 class="tleboxchung">Thẩm tra viên/ Lãnh đạo  
                                <asp:LinkButton ID="lkTTV" runat="server" Text="[ Mở ]"
                                    ForeColor="#0E7EEE" OnClick="lkTTV_Click"></asp:LinkButton>
                        </h4>
                        <div class="boder" style="padding: 10px;">
                            <asp:Panel ID="pnTTV" runat="server" Visible="false">

                                <table class="tableva">
                                    <tr>
                                        <td colspan="4"><a href="javascript:;" style="font-weight: bold; color: #0E7EEE; text-decoration: none;"
                                            onclick="OpenLS();">Lịch sử phân công</a></td>
                                        <tr>
                                            <td style="width: 120px;">Ngày phân công</td>
                                            <td style="width: 255px;">
                                                <asp:TextBox ID="txtNgayphancong" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayphancong" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayphancong" Mask="99/99/9999"
                                                    MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td style="width: 95px;">Thẩm tra viên</td>
                                            <td>
                                                <asp:DropDownList ID="dropTTV"
                                                    AutoPostBack=" true" OnSelectedIndexChanged="dropTTV_SelectedIndexChanged"
                                                    CssClass="chosen-select" runat="server" Width="250">
                                                </asp:DropDownList>
                                                <span style="margin-left: 10px;">
                                                    <asp:CheckBox ID="chkModify_TTV" runat="server" Text="Thay đổi" /></span></td>

                                        </tr>
                                    <tr>
                                        <td>Ngày TTV nhận đơn đề nghị và các tài liệu kèm theo</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayNhanTieuHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayNhanTieuHS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayNhanTieuHS" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Ngày TTV nhận hồ sơ </td>
                                        <td>
                                            <asp:TextBox ID="txtNgayNhanHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtNgayNhanHS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgayNhanHS" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td colspan="2"><i>(Lưu ý: hệ thống sẽ tự động tạo phiếu nhận tương ứng nếu mục 'Ngày TTV nhận hồ sơ' được chọn)</i></td>
                                    </tr>
                                    <tr>

                                        <td>Ngày Vụ GĐ nhận hồ sơ</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayGDNhanHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayGDNhanHS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayGDNhanHS" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>

                                        <td>Ngày phân công LĐ</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayPhanCong_LDV" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txtNgayPhanCong_LDV" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txtNgayPhanCong_LDV" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Lãnh đạo</td>
                                        <td>
                                            <asp:DropDownList ID="dropLanhDao"
                                                CssClass="chosen-select" runat="server" Width="250">
                                            </asp:DropDownList>
                                            <span style="margin-left: 10px;">
                                                <asp:CheckBox ID="chkModify_LanhDao" runat="server" Text="Thay đổi" /></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ngày phân công TP</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayPhanCong_TP" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txtNgayPhanCong_TP" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server" TargetControlID="txtNgayPhanCong_TP" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Thẩm phán</td>
                                        <td>
                                            <asp:DropDownList ID="dropThamPhan"
                                                CssClass="chosen-select" runat="server" Width="250">
                                            </asp:DropDownList>
                                            <span style="margin-left: 10px;">
                                                <asp:CheckBox ID="chkModify_TP" runat="server" Text="Thay đổi" /></span></td>
                                    </tr>
                                    <tr>
                                        <td>Ghi chú</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtGhiChu" CssClass="user"
                                                runat="server" Width="605px"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </div>
                    </div>

                    <!---------------------------->
                    <div style="float: left; margin-top: 8px; width: 100%;">
                        <div style="margin: 5px; text-align: center; width: 95%">
                            <asp:Button ID="cmdUpdate2" runat="server" CssClass="buttoninput" Text="Lưu"
                                OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                            <%--<asp:Button ID="cmdUpdateAndNew2" runat="server" CssClass="buttoninput"
                                OnClientClick="return validate();"
                                Text="Lưu & Thêm mới" OnClick="cmdUpdateAndNew_Click" />--%>
                            <asp:Button ID="cmdLamMoi2" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLamMoi_Click" />
                            <asp:Button ID="cmdQuaylai2" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                        </div>
                    </div>

                    <!---------------------------->
                    <asp:Panel ID="pnHoSoVKS" runat="server" Visible="false">
                        <div style="float: left; margin-bottom: 10px; width: 100%; position: relative; margin-top: 10px;">
                            <h4 class="tleboxchung">Hồ sơ kháng nghị của VKS</h4>
                            <div class="boder" style="padding: 2%; width: 96%;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 110px;">Số<span class="batbuoc">*</span></td>
                                        <td style="width: 255px;">
                                            <asp:TextBox ID="txtVKS_So" CssClass="user" runat="server"
                                                Width="242px"></asp:TextBox>

                                        </td>
                                        <td style="width: 110px;">Ngày<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtVKS_Ngay" CssClass="user" runat="server"
                                                Width="110px" AutoPostBack="true"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender13" runat="server" TargetControlID="txtVKS_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender13" runat="server" TargetControlID="txtVKS_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Đơn vị chuyển HS<span class="batbuoc">*</span></td>
                                        <td colspan="3">
                                            <asp:DropDownList ID="dropVKS_NguoiKy" CssClass="chosen-select"
                                                runat="server" Width="498px">
                                            </asp:DropDownList>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:Button ID="cmdUpdateVKS" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdateVKS_Click" OnClientClick="return validate_vks();" />
                                            <asp:Button ID="cmdXoa_VKS" runat="server" CssClass="buttoninput"
                                                Text="Xóa" OnClick="cmdXoa_VKS_Click"
                                                OnClientClick="return confirm('Bạn muốn xóa thông tin này?');" />
                                            <asp:Button ID="cmdQuaylai4" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                                        </td>

                                    </tr>

                                </table>
                                <div style="margin: 5px; width: 95%; color: red;">
                                    <asp:Label ID="lttMsgHSKN_VKS" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                    <!---------------------------->
                    <asp:Panel ID="pnThulyXXGDT" runat="server" Visible="false">
                        <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Thông tin thụ lý xét xử GĐT,TT</h4>
                            <div class="boder" style="padding: 2%; width: 96%;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 110px;">Ngày VKS trả/chuyển HS</td>
                                        <td style="width: 255px;">
                                            <asp:TextBox ID="txtNgayVKSTraHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender14" runat="server" TargetControlID="txtNgayVKSTraHS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender14" runat="server" TargetControlID="txtNgayVKSTraHS" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                        </td>
                                        <td style="width: 110px;"></td>
                                        <td></td>
                                    </tr>

                                    <tr>
                                        <td>Số thụ lý XX GĐT</td>
                                        <td>
                                            <asp:TextBox ID="txtSOTHULYXXGDT" CssClass="user" runat="server"
                                                Width="242px"></asp:TextBox>
                                        </td>
                                        <td>Ngày thụ lý GĐT<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayTHULYXXGDT" CssClass="user" runat="server" Width="110px" AutoPostBack="true"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender15" runat="server" TargetControlID="txtNgayTHULYXXGDT" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender15" runat="server" TargetControlID="txtNgayTHULYXXGDT" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:Button ID="cmdUpdateTTXX" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdateTTXX_Click" OnClientClick="return validate_tlxxGDT();" />
                                            <asp:Button ID="cmdXoaTTXX" runat="server" CssClass="buttoninput"
                                                Text="Xóa" OnClick="cmdXoa_TTXX_Click"
                                                OnClientClick="return confirm('Bạn muốn xóa thông tin này?');" />
                                            <asp:Button ID="cmdQuaylai5" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                                        </td>
                                    </tr>
                                </table>
                                <div style="margin: 5px; width: 95%; color: red;">
                                    <asp:Label ID="lttMsgTLXX" runat="server"></asp:Label>
                                </div>

                            </div>
                        </div>
                    </asp:Panel>
                    <!---------------------------->
                </div>

                <div style="margin: 5px; width: 95%; color: red;">
                    <asp:Label ID="lttMsg" runat="server"></asp:Label>
                </div>
            </div>
        </div>
    </div>
    <script>
        function Loadds_bc() {
            $("#<%= cmd_loadbc.ClientID %>").click();
        }
        function Loadds_nguoikn() {
            $("#<%= cmd_loadkn.ClientID %>").click();
        }
        function popup_them_sua_ds(VuAnID, DUONGSUID) {
            var link = "";
             link = "/QLAN/GDTTT/VuAn/Popup/pBiCao_cc.aspx?hsID=" + VuAnID + "&DS_ID=" + DUONGSUID;
            var width = 900;
            var height = 800;
            PopupCenter(link, "Cập nhật thông tin bị can", width, height);
        }
        function popup_them_sua_nguoikn(VuAnID, DUONGSUID) {
            var link = "";
            link = "/QLAN/GDTTT/VuAn/Popup/pNguoiKN.aspx?hsID=" + VuAnID + "&DS_ID=" + DUONGSUID;
            var width = 900;
            var height = 800;
            PopupCenter(link, "Cập nhật thông tin Người khiếu nại", width, height);
        }

        function popup_them_td_cc(DuongSuID) {
            var link = "/QLAN/GDTTT/VuAn/popup/p_ToiDanh_cc.aspx?duongsuid=" + DuongSuID;
            var width = 800;
            var height = 500;
            PopupCenter(link, "Thêm tội danh", width, height);
        }
       
           
        function OpenLS() {
            var link = 'Popup/pPCCaBoHistory.aspx?vID=<%=hddVuAnID%>';
            PopupCenter(link, 'Lịch sử phân công', 1000, 850);
        }

    </script>
    <script>
        function validate() {
            var ddl_LOAI_GDTTT = document.getElementById('<%=ddl_LOAI_GDTTT.ClientID%>');
            var value_LOAI_GDTTT = ddl_LOAI_GDTTT.options[ddl_LOAI_GDTTT.selectedIndex].value;
            if (value_LOAI_GDTTT == "0") {
                alert("Bạn chưa chọn Thủ tục giải quyết. Hãy kiểm tra lại!");
                ddl_LOAI_GDTTT.focus();
                return false;
            }
            //if (!validate_thuly())
            //   return false;
            if (!validate_banan_qd())
                return false;
            return true;
        }
        function validate_thuly() {
            var txtSoThuLy = document.getElementById('<%=txtSoThuLy.ClientID%>');
            if (!Common_CheckTextBox(txtSoThuLy, 'Số thụ lý'))
                return false;
            //-----------------------------
            var txtNgayThuLy = document.getElementById('<%=txtNgayThuLy.ClientID%>');
            if (!CheckDateTimeControl(txtNgayThuLy, "Ngày thụ lý"))
                return false;

            //-----------------------------
            return true;
        }

        function validate_banan_qd() {
            var value_change = "";
            //-----------------------------ddlLoaiBA
            var hddIsAnPT = document.getElementById('<%=hddIsAnPT.ClientID%>');
            if (hddIsAnPT.value == "GDT") {
                var txtSoQĐGDT = document.getElementById('<%=txtSoQĐGDT.ClientID%>');
                if (!Common_CheckTextBox(txtSoQĐGDT, 'Số QĐ Giám đốc thẩm'))
                    return false;
                var txtNgayGDT = document.getElementById('<%=txtNgayGDT.ClientID%>');
                if (!CheckDateTimeControl(txtNgayGDT, "Ngày QĐ Giám đốc thẩm"))
                    return false;
                //-----------------------------
                var dropToaGDT = document.getElementById('<%=dropToaGDT.ClientID%>');
                value_change = dropToaGDT.options[dropToaGDT.selectedIndex].value;
                if (value_change == "0") {
                    alert("Bạn chưa chọn Tòa án ra Quyết định Giám đốc thẩm. Hãy kiểm tra lại!");
                    dropToaGDT.focus();
                    return false;
                }
            }
            else if (hddIsAnPT.value == "PT") {
                var txtSoBA = document.getElementById('<%=txtSoBA.ClientID%>');
                if (!Common_CheckTextBox(txtSoBA, 'Số BA/QĐ phúc thẩm'))
                    return false;
                var txtNgayBA = document.getElementById('<%=txtNgayBA.ClientID%>');
                if (!CheckDateTimeControl(txtNgayBA, "Ngày BA/QĐ phúc thẩm"))
                    return false;
                //-----------------------------
                var dropToaAn = document.getElementById('<%=dropToaAn.ClientID%>');
                value_change = dropToaAn.options[dropToaAn.selectedIndex].value;
                if (value_change == "0") {
                    alert("Bạn chưa chọn Tòa án thụ lý vụ việc phúc thẩm. Hãy kiểm tra lại!");
                    dropToaAn.focus();
                    return false;
                }
            }
            else if (hddIsAnPT.value == "ST") {
                var txtSoBA_ST = document.getElementById('<%=txtSoBA_ST.ClientID%>');
                if (!Common_CheckTextBox(txtSoBA_ST, 'Số BA/QĐ sơ thẩm'))
                    return false;
                var txtNgayBA_ST = document.getElementById('<%=txtNgayBA_ST.ClientID%>');
                if (!CheckDateTimeControl(txtNgayBA_ST, "Ngày BA/QĐ sơ thẩm"))
                    return false;
                //-----------------------------
                var dropToaAnST = document.getElementById('<%=dropToaAnST.ClientID%>');
                value_change = dropToaAnST.options[dropToaAnST.selectedIndex].value;
                if (value_change == "0") {
                    alert("Bạn chưa chọn Tòa án thụ lý vụ việc  sơ thẩm. Hãy kiểm tra lại!");
                    dropToaAnST.focus();
                    return false;
                }

            }
            //---------Check Dieu luat ap dung----------------
            var dropDieuLuat = document.getElementById('<%=dropDieuLuat.ClientID%>');
            value_change = dropDieuLuat.options[dropDieuLuat.selectedIndex].value;
            if (value_change == "0") {
                alert("Bạn chưa chọn Điều luật áp dụng cho Thống kê. Hãy kiểm tra lại!");
                dropDieuLuat.focus();
                return false;
            }
            //-----------------------------
            return true;
        }
        function validate_ttv() {
          <%--  var txtNgayphancong = document.getElementById('<%=txtNgayphancong.ClientID%>');
            var dropTTV = document.getElementById('<%=dropTTV.ClientID%>');
            var value_change = dropTTV.options[dropTTV.selectedIndex].value;
            if (value_change != "0") {
                if (!CheckDateTimeControl(txtNgayphancong, "Ngày phân công TTV"))
                    return false;
            }--%>

            return true;
        }
        function validate_form_bicao() {
            return true;
        }

        function validate_vks() {
            var txtVKS_So = document.getElementById('<%=txtVKS_So.ClientID%>');
            if (!Common_CheckTextBox(txtVKS_So, 'Số hồ sơ VKS'))
                return false;
            //-----------------------------
            var txtVKS_Ngay = document.getElementById('<%=txtVKS_Ngay.ClientID%>');
            if (!CheckDateTimeControl(txtVKS_Ngay, "Ngày hồ sơ VKS"))
                return false;

            //-----------------------------
            var dropVKS = document.getElementById('<%=dropVKS_NguoiKy.ClientID%>');
            value_change = dropVKS.options[dropVKS_chuyen.selectedIndex].value;
            if (value_change == "0") {
                alert("Bạn chưa chọn 'Đơn vị chuyển hồ sơ'. Hãy kiểm tra lại!");
                dropVKS.focus();
                return false;
            }
            //-----------------------------

            return true;
        }

        function validate_tlxxGDT() {
            <%--var txtNgaySOTHULYXXGDT = document.getElementById('<%=txtNgaySOTHULYXXGDT.ClientID%>');
            if (!Common_CheckTextBox(txtSoThuLy, 'Số thụ lý'))
                return false;--%>
            //-----------------------------
            var txtNgaySOTHULYXXGDT = document.getElementById('<%=txtNgayTHULYXXGDT.ClientID%>');
            if (!CheckDateTimeControl(txtNgaySOTHULYXXGDT, "Ngày thụ lý xet xử GĐT"))
                return false;

            //-----------------------------
            return true;
        }

    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
