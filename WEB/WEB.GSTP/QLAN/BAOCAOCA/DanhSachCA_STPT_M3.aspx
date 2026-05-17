<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="DanhSachCA_STPT_M3.aspx.cs" Inherits="WEB.GSTP.QLAN.BAOCAOCA.DanhSachCA_STPT_M3" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <link href="../../../UI/css/Vanbanden.css" rel="stylesheet" />
    <style>
        .CustomWidth {
        }

        .modalPopup .header {
            background-color: #a4212a;
            height: 30px;
            color: White;
            line-height: 22px;
            text-align: center;
            font-weight: bold;
        }
    </style>

    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">


                    <asp:Panel ID="pn_Filter" runat="server">

                        <tr>
                            <td colspan="2">
                                <div class="boxchung">
                                    <h4 class="tleboxchung">Tìm kiếm</h4>
                                    <div class="boder" style="padding: 10px;">
                                        <table class="table1">
                                            <tr>
                                                <td>
                                                    <div style="float: left; width: 1050px">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Loại án</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="248px"></asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tòa xét xử</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="DropToaAn" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="DropToaAn_SelectedIndexChanged"></asp:DropDownList>
                                                        </div>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 8px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tội danh/ QHPL</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txt_toidanh" CssClass="user" runat="server" Width="238px"></asp:TextBox>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Mã vụ án</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtMaVuViec" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 8px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Bị can /Bị cáo/ Đương sự</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtBiCan" CssClass="user" runat="server" Width="240px" MaxLength="50"></asp:TextBox>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Cấp xét xử</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="dropCapxx" CssClass="chosen-select" runat="server" Width="246px"
                                                                AutoPostBack="True" OnSelectedIndexChanged="dropCapxx_SelectedIndexChanged">
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 4px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Số Thụ lý</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtSOTHULY" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Từ ngày</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txt_NGAYTHULY_TU" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txt_NGAYTHULY_TU" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txt_NGAYTHULY_TU" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NGAYTHULY_TU" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>
                                                        <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Đến ngày</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txt_NGAYTHULY_DEN" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txt_NGAYTHULY_DEN" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txt_NGAYTHULY_DEN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NGAYTHULY_DEN" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 2px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tình trạng GQ</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="DropTINHTRANG_GIAIQUYET" CssClass="chosen-select" runat="server" Width="248px"
                                                                AutoPostBack="True" OnSelectedIndexChanged="DropTINHTRANG_GIAIQUYET_SelectedIndexChanged">
                                                                <asp:ListItem Value="0" Text="-- Tất cả --"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text=" Chưa giải quyết xong"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text=" Đã giải quyết xong"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Từ ngày </div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="txtTuNgay_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>
                                                        <div style="float: left; width: 65px; text-align: center; margin-right: 10px;">Đến ngày</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 6px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thẩm phán</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                            <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Số BA/QĐ </div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtSoQD" CssClass="user" runat="server" Width="70px"></asp:TextBox>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Ngày BA/QĐ</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txt_NgayQD" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txt_NgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txt_NgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NgayQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td style="width: 150px;" align="left"></td>
                            <td align="left">
                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" />
                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                <asp:Button ID="btn_baocao" runat="server" CssClass="buttoninput" Text="In báo cáo" OnClick="btn_baocao_Click" />
                            </td>
                        </tr>

                        <tr>
                            <td style="width: 150px;" align="left">
                                <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red" Font-Size="17px"></asp:Label></td>
                        </tr>

                    </asp:Panel>


                    <asp:Panel ID="pn_DanhsachAn" runat="server">

                        <tr>
                            <td colspan="2" align="left">
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false"
                                            CssClass="back" Visible="true"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                        <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                        <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                        <asp:DropDownList ID="dropPageSize" runat="server" Width="55px" CssClass="so"
                                            AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                                            <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                            <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                            <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                            <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                            <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                            <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div>
                                    <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                        PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                        ItemStyle-CssClass="chan" Width="100%"
                                        OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                        <Columns>
                                            <asp:BoundColumn DataField="STT" Visible="false"></asp:BoundColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>STT</HeaderTemplate>
                                                <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="LOAIAN" HeaderText="Loại án"
                                                HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="center"
                                                HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                                <HeaderTemplate>
                                                    Số,ngày thụ lý
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("SONGAYTHULY")%>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>                                            
                                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                                <HeaderTemplate>
                                                    Thông tin vụ án
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("TENVUVIEC")%>
                                                    <%#Eval("CAPXX")%>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                                <HeaderTemplate>
                                                    Tình trạng giải quyết
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("TEN_THAMPHAN")%>
                                                    <%#Eval("TINHHINH_GIAIQUYET")%>
                                                    <%#Eval("SOLUONG_KC")%>
                                                    <%#Eval("SOLUONG_KN")%>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Thao tác
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                        <asp:LinkButton ID="lblChitiet" runat="server" Text="Chi tiết" ForeColor="#0e7eee"
                                                            CausesValidation="false" CommandName="Sua"
                                                            CommandArgument='<%#Eval("STT") %>'>
                                                        </asp:LinkButton>
                                                        <br>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    </asp:DataGrid>
                                </div>
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false"
                                            CssClass="back" Visible="true"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false"
                                            CssClass="active" Visible="false"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                        <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                        <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                        <asp:DropDownList ID="dropPageSize2" runat="server" Width="55px" CssClass="so"
                                            AutoPostBack="True" OnSelectedIndexChanged="dropPageSize2_SelectedIndexChanged">
                                            <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                            <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                            <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                            <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                            <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                            <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </td>
                        </tr>

                    </asp:Panel>

                    <asp:Panel ID="pn_DanhsachToaan" runat="server">
                    </asp:Panel>

                </table>
            </div>
        </div>
    </div>



    <div runat="server" id="modalpopupCapnhat" style="display: none; visibility: hidden; position: absolute!important;"></div>
    <cc1:ModalPopupExtender ID="mp1" BehaviorID="mp1_Capnhat"
        runat="server" PopupControlID="pnCapnhat"
        TargetControlID="modalpopupCapnhat"
        PopupDragHandleControlID="id_header"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="pnCapnhat" runat="server" align="center" CssClass="modalPopup" Style="display: none; height: 150px; width: 550px;">
        <div class="box_nd" style="width: 500px;">
            <div class="truong">
                <div>
                    <div>
                        <table>
                            <tr>
                                <td>Lý do xóa<span class="batbuoc">(*)</span></td>
                                <td style="padding-left: 5px;">
                                    <asp:DropDownList ID="ddlLydoXoaSothuly" CssClass="user" runat="server" Style="width: 300px; text-align: center">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
        </div>
        <div class="box_nd" style="width: 500px;">
            <div class="truong">

                <div>
                    <div>
                        <table>
                            <tr>
                                <td style="text-align: left;" colspan="6">
                                    <asp:Button ID="btnClose" runat="server" CssClass="buttoninput" Text="Đóng" OnClientClick="javascript:HideModalPopup();" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </asp:Panel>



    <script type="text/javascript">
        function HideModalPopup() {
            $find("mp1_Capnhat").hide();
            return false;
        }
    </script>


    <script>
        function LoadDanhsachHoSo() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
