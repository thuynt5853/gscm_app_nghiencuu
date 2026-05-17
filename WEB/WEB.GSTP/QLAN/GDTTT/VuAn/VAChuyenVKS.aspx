<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="VAChuyenVKS.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.VAChuyenVKS" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddGUID" runat="server" Value="" />
    <asp:HiddenField ID="hddNext" runat="server" Value="0" />
    <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
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
            float: left;
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
            }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">

                <div style="margin: 5px; width: 95%; color: red;">
                    <asp:Label ID="lttMsgT" runat="server"></asp:Label>
                </div>
                <div class="boxchung">
                    <!-------------------------------------------------->
                    <div style="float: left; margin-top: 8px; width: 100%;">
                        <h4 class="tleboxchung">1. Thông tin BA/QĐ đề nghị GĐT,TT</h4>
                        <div class="boder" style="padding: 2%; width: 96%;">
                            <asp:HiddenField ID="hddInputAnST" runat="server" Value="0" />
                            <table class="tableva">
                                <tr>
                                    <td style="width: 120px;">Loại bản án</td>
                                    <td style="width: 255px;">
                                        <asp:DropDownList ID="ddlLoaiBA" CssClass="chosen-select"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiBA_SelectedIndexChanged"
                                            runat="server" Width="250px">
                                            <asp:ListItem Value="1" Text="Phúc thẩm"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="Sơ thẩm"></asp:ListItem>
                                        </asp:DropDownList>

                                    </td>     
                                    <td style="width: 95px;">Loại án</td>
                                    <td>
                                       <asp:DropDownList ID="dropLoaiAn" runat="server"
                                            Width="250px" CssClass="chosen-select"
                                            AutoPostBack="true" OnSelectedIndexChanged="dropLoaiAn_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>

                                </tr>
                                <!---------------An PT----------------------------->
                             <asp:Panel ID="pnPhucTham" runat="server">
                                <tr>
                                    <td style="width: 120px;">Số BA/QĐ Phúc thẩm<span class="batbuoc">*</span></td>
                                    <td style="width: 255px;">
                                        <asp:TextBox ID="txtSoBA" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                    <td  style="width: 120px;">Ngày BA/QĐ Phúc thẩm<span class="batbuoc">*</span></td>
                                    <td  style="width: 255px;">
                                        <asp:TextBox ID="txtNgayBA" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayBA" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayBA"
                                            Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                </tr>
                                <tr>
                                    <td>Tòa án xét xử PT<span class="batbuoc">*</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="dropToaAn" CssClass="chosen-select"
                                            AutoPostBack="true" OnSelectedIndexChanged="dropToaAn_SelectedIndexChanged"
                                            runat="server" Width="250px">
                                        </asp:DropDownList>
                                    </td>
                                    
                                </tr>
                                </asp:panel>
                                <!-----------An ST--------------------------------->
                                <asp:Panel ID="pnAnST" runat="server" Visible="false">

                                    <tr>
                                        <td>Số BA/QĐ Sơ thẩm</td>
                                        <td>
                                            <asp:TextBox ID="txtSoBA_ST" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                        <td>Ngày BA/QĐ Sơ thẩm</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayBA_ST" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtNgayBA_ST" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtNgayBA_ST"
                                                Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tòa án xét xử sơ thẩm</td>
                                        <td>
                                            <asp:DropDownList ID="dropToaAnST" CssClass="chosen-select"
                                                runat="server" Width="250px">
                                            </asp:DropDownList>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    
                                </asp:Panel>
                           </table>
                         </div>
                       
                               
                                <!----------------------------->
                   
                                  
                    <asp:Panel ID="pnTTV" runat="server">
                             <div style="float: left; margin-bottom: 10px; width: 100%; position: relative; margin-top: 10px;">
                               <h4 class="tleboxchung">2. Thẩm tra viên/ Lãnh đạo</h4>
                               <div class="boder" style="padding: 2%; width: 96%;">
                                 <table class="table1">
                                    <tr>
                                        <td>Ngày phân công TTV</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayphancong" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayphancong" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayphancong" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td style="width: 120px;">Thẩm tra viên</td>
                                        <td style="width: 255px;">
                                            <asp:DropDownList ID="dropTTV"
                                                AutoPostBack=" true" OnSelectedIndexChanged="dropTTV_SelectedIndexChanged"
                                                CssClass="chosen-select" runat="server" Width="250">
                                            </asp:DropDownList></td>
                                        <td style="width: 95px;">Lãnh đạo Vụ</td>
                                        <td>
                                            <asp:DropDownList ID="dropLanhDao"
                                                CssClass="chosen-select" runat="server" Width="250">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ngày TTV nhận đơn đề nghị và các tài liệu kèm theo</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayNhanTieuHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayNhanTieuHS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayNhanTieuHS" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Ngày Vụ GĐ nhận hồ sơ</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayGDNhanHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayGDNhanHS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayGDNhanHS" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Thẩm phán</td>
                                        <td>
                                            <asp:DropDownList ID="dropThamPhan"
                                                CssClass="chosen-select" runat="server" Width="250">
                                            </asp:DropDownList></td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>

                                        <td>Ghi chú</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtGhiChu" CssClass="user"
                                                runat="server" Width="605px"></asp:TextBox>
                                        </td>
                                    </tr>
                            </table>
                            </div>
                        </div>
                    </asp:Panel>            
                                

                    <div style="float: left; margin-bottom: 1px; width: 100%; position: relative; margin-top: 1px;">
                         <div style="margin: 5px; width: 95%; color: red;">
                                    <asp:Label ID="lblMsgLuuBA" runat="server"></asp:Label>
                        </div>
                             <table class="table1">
                                <tr>
                                    <td colspan="4">
                                        <div style="margin: 1px; text-align: left; width: 900px; padding-left:145px">
                                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                                          
                                            <%--<asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLamMoi_Click" />--%>
                                            <asp:Button ID="cmdQuaylai3" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                       
                    </div>

                     <!--Duong su-------------------------->
                    <asp:Panel ID="pnDuongSuVuan" runat="server" Visible ="false">   
                          <div style="float: left; margin-top: 8px; width: 100%;">
                             <h4 class="tleboxchung">3. Thông tin Đương sự</h4>
                            <div class="boder" style="padding: 2%; width: 96%;">
                                <table class="tableva" style="width:550pt">
                             <!-------------------------------->
                                    <tr>
                                        <td style="width:120pt">Quan hệ pháp luật<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:DropDownList ID="dropQHPL"
                                                CssClass="chosen-select" runat="server" Width="250">
                                            </asp:DropDownList></td>
                                        <td style="display: none;">Quan hệ PL tranh chấp<span class="batbuoc">*</span></td>
                                        <td style="display: none;">
                                            <asp:DropDownList ID="dropQHPLThongKe"
                                                CssClass="chosen-select" runat="server" Width="250px">
                                                <asp:ListItem Value="0" Text="Chọn"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>

                                    <!----------------------------->
                                    <asp:Panel ID="pnNguyenDon" runat="server">
                                        <tr>
                                            <td colspan="4" style="height: 5px;"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4"><b style="margin-right: 10px;">Nguyên đơn/ Người khởi kiện</b>
                                                <asp:HiddenField ID="hddSoND" runat="server" Value="1"/>
                                                <asp:LinkButton ID="lkThemND" runat="server" CssClass="buttonpopup them_user clear_bottom" ToolTip="Thêm Nguyên đơn/ Người khởi kiện"
                                                    OnClientClick="return validate();" OnClick="lkThemND_Click">&nbsp;</asp:LinkButton>
                                                <asp:CheckBox ID="chkND" runat="server" Text="Có địa chỉ"
                                                    AutoPostBack="true" OnCheckedChanged="chkND_CheckedChanged" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" style="vertical-align: top;">
                                                <asp:Repeater ID="rptNguyenDon" runat="server" OnItemCommand="rptNguyenDon_ItemCommand" OnItemDataBound="rptDuongSu_ItemDataBound">
                                                    <HeaderTemplate>
                                                        <table class="table_list" width="100%" border="1">
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td width="15px" style="text-align: center;">
                                                                <asp:HiddenField ID="hddDuongSuID" runat="server" Value='<%#Eval("ID") %>' />
                                                                <%# Container.ItemIndex + 1 %></td>
                                                            <td>
                                                                <asp:TextBox ID="txtTen" Width="96%" CssClass="user"
                                                                    placeholder="Họ tên(*)"
                                                                    runat="server" Text='<%#Eval("TenDuongSu") %>'></asp:TextBox></td>

                                                            <asp:Panel ID="pn" runat="server">
                                                                <td width="250px">
                                                                    <asp:HiddenField ID="hddHuyenID" runat="server" Value='<%# Eval("HUYENID") %>' />
                                                                    <asp:DropDownList ID="ddlTinhHuyen" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                                </td>
                                                                <td width="190px">
                                                                    <asp:TextBox ID="txtDiachi" Width="96%"
                                                                        placeholder="Địa chỉ chi tiết"
                                                                        CssClass="user" runat="server"
                                                                        Text='<%# Eval("DiaChi") %>'></asp:TextBox></td>
                                                            </asp:Panel>
                                                            <td width="30px">
                                                                <div align="center">
                                                                    <asp:LinkButton ID="lkXoa" Visible='<%#(Convert.ToInt16(Eval("IsDelete")+"")==0)? false:true %>' runat="server"
                                                                        CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                        ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                    <FooterTemplate></table></FooterTemplate>
                                                </asp:Repeater>

                                            </td>
                                        </tr>
                                    </asp:Panel>

                                    <!----------------------------->
                                    <asp:Panel ID="pnBiDon" runat="server">
                                        <tr>
                                            <td colspan="4" style="height: 5px;"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4"><b style="margin-right: 10px;">Bị đơn/ Người  bị kiện</b>
                                             <asp:HiddenField ID="hddSoBD" runat="server" Value="1"/>
                                             
                                                <asp:LinkButton ID="lkThemBD" runat="server" CssClass="buttonpopup them_user clear_bottom" ToolTip="Thêm bị đơn/ Người bị kiện"
                                                    OnClientClick="return validate();" OnClick="lkThemBD_Click">&nbsp;</asp:LinkButton>
                                                <asp:CheckBox ID="chkBD" runat="server" Text="Có địa chỉ"
                                                    AutoPostBack="true" OnCheckedChanged="chkBD_CheckedChanged" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" style="vertical-align: top;">

                                                <asp:Repeater ID="rptBiDon" runat="server"
                                                    OnItemCommand="rptBiDon_ItemCommand" OnItemDataBound="rptDuongSu_ItemDataBound">
                                                    <HeaderTemplate>
                                                        <table class="table_list" width="100%" border="1">
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td width="15px" style="text-align: center;">
                                                                <asp:HiddenField ID="hddDuongSuID" runat="server" Value='<%#Eval("ID") %>' />
                                                                <%# Container.ItemIndex + 1 %></td>
                                                            <td>
                                                                <asp:TextBox ID="txtTen" Width="96%" CssClass="user"
                                                                    placeholder="Họ tên bị đơn (*)"
                                                                    runat="server" Text='<%#Eval("TenDuongSu") %>'></asp:TextBox></td>
                                                            <asp:Panel ID="pn" runat="server">
                                                                <td width="250px">
                                                                    <asp:HiddenField ID="hddHuyenID" runat="server" Value='<%# Eval("HUYENID") %>' />
                                                                    <asp:DropDownList ID="ddlTinhHuyen" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                                </td>
                                                                <td width="190px">
                                                                    <asp:TextBox ID="txtDiachi" Width="96%"
                                                                        placeholder="Địa chỉ chi tiết" CssClass="user" runat="server" Text='<%# Eval("DiaChi") %>'></asp:TextBox></td>
                                                            </asp:Panel>
                                                            <td width="30px">
                                                                <div align="center">
                                                                    <asp:LinkButton ID="lkXoa" Visible='<%#(Convert.ToInt16(Eval("IsDelete")+"")==0)? false:true %>' runat="server"
                                                                        CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                        ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                    <FooterTemplate></table></FooterTemplate>
                                                </asp:Repeater>

                                            </td>
                                        </tr>
                                    </asp:Panel>

                                    <!----------------------------->
                                    <asp:Panel ID="pnDsKhac" runat="server">
                                        <tr>
                                            <td colspan="4" style="height: 5px;"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4"><b style="margin-right: 10px;">Người có QL&NVLQ</b>
                                         
                                                  <asp:HiddenField ID="hddSoDSKhac" runat="server" Value="0"/>
                                                <asp:LinkButton ID="lkThemDSKhac" runat="server" CssClass="buttonpopup them_user clear_bottom" ToolTip="Thêm Người có QL&NVLQ"
                                                    OnClientClick="return validate();" OnClick="lkThemDSKhac_Click">&nbsp;</asp:LinkButton>
                                                <asp:CheckBox ID="chkDSKhac" runat="server" Text="Có địa chỉ"
                                                    AutoPostBack="true" OnCheckedChanged="chkDSKhac_CheckedChanged" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <asp:Repeater ID="rptDsKhac" runat="server"
                                                    OnItemCommand="rptDsKhac_ItemCommand" OnItemDataBound="rptDuongSu_ItemDataBound">
                                                    <HeaderTemplate>
                                                        <table class="table_list" width="100%" border="1">
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td style="text-align: center; width: 15px;">
                                                                <asp:HiddenField ID="hddDuongSuID" runat="server" Value='<%#Eval("ID") %>' />
                                                                <%# Container.ItemIndex + 1 %></td>
                                                            <td>
                                                                <asp:TextBox ID="txtTen" Width="96%" CssClass="user"
                                                                    placeholder="Họ tên"
                                                                    runat="server" Text='<%#Eval("TenDuongSu") %>'></asp:TextBox></td>
                                                            <asp:Panel ID="pn" runat="server">
                                                                <td width="250px">
                                                                    <asp:HiddenField ID="hddHuyenID" runat="server" Value='<%# Eval("HUYENID") %>' />
                                                                    <asp:DropDownList ID="ddlTinhHuyen" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                                </td>
                                                                <td style="width: 190px">
                                                                    <asp:TextBox ID="txtDiachi"
                                                                        placeholder="Địa chỉ chi tiết" Width="96%" CssClass="user" runat="server" Text='<%# Eval("DiaChi") %>'></asp:TextBox></td>
                                                            </asp:Panel>
                                                            <td width="30px">
                                                                <div align="center">
                                                                    <asp:LinkButton ID="lkXoa" Visible='<%#(Convert.ToInt16(Eval("IsDelete")+"")==0)? false:true %>' runat="server"
                                                                        CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                    <FooterTemplate></table></FooterTemplate>
                                                </asp:Repeater>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                </table>
                            </div>
                            <div style="float: left; margin-bottom: 1px; width: 100%; position: relative; margin-top: 1px;">
                                 <div style="margin: 5px; width: 95%; color: red;">
                                    <asp:Label ID="lblmsDuongsu" runat="server"></asp:Label>
                                </div>
                                 <table class="table1">
                                    <tr>
                                        <td colspan="4">
                                            <div style="margin: 1px; text-align: left; width: 900px; padding-left:145px">
                                                <asp:Button ID="bnLuuDS" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdLuuDS_Click" OnClientClick="return validateDS();" />
                                          
                                                <%--<asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLamMoi_Click" />--%>
                                                <%--<asp:Button ID="bnXoaDS" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdXoaDS_Click" />--%>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                               
                            </div>
                        </div>
                    <!---------------------------->
                     </asp:Panel>
                    <!--Bi án-------------------------->
                    <asp:Panel ID="pnBian" runat="server" Visible ="false">   
                       <div style="float: left; margin-bottom: 10px; width: 100%; position: relative; margin-top: 10px;">
                            <h4 class="tleboxchung">3. Thông tin Bị cáo</h4>
                            <div class="boder" style="padding: 2%; width: 96%;">
                                <asp:HiddenField ID="HiddenField1" runat="server" Value="0" />
                                <asp:HiddenField ID="hddBiCaoID" runat="server" />
                        
                                <table class="tableva">
                               
                                        <asp:Panel ID="pnBiCaoToiDanh" runat="server">
                                             <tr>
                                                <td style="width: 110px;">Loại</td>
                                                <td colspan="2"  style="width:255px;">
                                                    <asp:CheckBox ID="chkBiCao" runat="server" Text="Bị cáo"
                                                        AutoPostBack="true" />
                                                    <asp:CheckBox ID="chkBCDauVu" runat="server" Text="Đầu vụ"
                                                        AutoPostBack="true"/>
                                                </td>
                                            </tr>
                                            <tr>
                                        
                                               <td style="width: 110px;">Họ tên</td>
                                                <td colspan="2"  style="width:255px;">
                                                    <span style="float: left;">
                                                        <asp:TextBox ID="txtBC_HoTen" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    </span></td>
                                            </tr>
                                            <tr>
                                                <td style="width: 110px;">Mức án</td>
                                                <td colspan="2"  style="width:255px;">
                                                    <asp:TextBox ID="txtBC_MucAn" CssClass="user" runat="server"
                                                        Width="242px"></asp:TextBox></td>
                                            </tr>
                                             <tr>
                                                <td style="width: 110px;">Năm sinh</td>
                                                <td colspan="2"  style="width:255px;">
                                                    <asp:DropDownList ID="ddlNamsinh" CssClass="chosen-select"
                                                    runat="server" Width="250px"></asp:DropDownList>

                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="vertical-align: top;width: 110px;">Tội danh</td>
                                                <td style="width:200px;">
                                                    <span style="float: left;">
                                                        <asp:DropDownList ID="dropBiCao_ToiDanh" runat="server"
                                                            CssClass="chosen-select" Width="600px">
                                                        </asp:DropDownList></span>
                                                    </td>
                                                <td>
                                                    <span style="float: left; margin-left: 10px;">
                                                        <asp:LinkButton ID="lkBiCao_SaveToiDanh" runat="server"
                                                            OnClick="lkBiCao_SaveToiDanh_Click"
                                                            CssClass="button_empty" ToolTip="Thêm tội danh">Thêm tội danh</asp:LinkButton></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" style="vertical-align: top;">
                                               
                                                    <asp:Repeater ID="rptToiDanh" runat="server" Visible="false" OnItemCommand="rptToiDanh_ItemCommand">
                                                        <HeaderTemplate>
                                                            <div class="title_ds">Danh sách tội danh</div>
                                                            <table class="table2" style="width: 100%;" border="1">
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td style="width: 30px; text-align: center;"><%# Container.ItemIndex + 1 %></td>
                                                                <td>
                                                                    <asp:HiddenField runat="server" ID="hddDSToiDanhID" Value='<%#Eval("ID") %>' />
                                                                    <%#Eval("TenToiDanh") %></td>
                                                                <td style="width: 20px">
                                                                    <asp:ImageButton ImageUrl="/UI/img/delete.png" runat="server" Width="16px"
                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa tội danh này của bị cáo? ');" />
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate></table></FooterTemplate>
                                                    </asp:Repeater>

                                                </td>
                                            </tr>
                                             <tr>
                                                <td></td>
                                                <td colspan="2" >
                                                    <asp:Button ID="cmdSaveDSHinhSu" runat="server" CssClass="buttoninput" Text="Lưu"  OnClick="cmdSaveDSHinhSu_Click" />
                                                    <asp:Button ID="cmdRefresh" runat="server" CssClass="buttoninput" Text="Làm mới"
                                                        OnClick="cmdRefresh_Click" />
                                                </td>
                                            </tr>
                                        </asp:Panel>

                                    <tr>
                                        <td colspan="4">
                                            <div style="color: red; font-size: 15px; text-align: center;">
                                                <asp:Literal ID="lttMsgBC" runat="server"></asp:Literal>
                                            </div>
                                            <table class="table2" width="900px" border="1">
                                                <tr class="header">
                                                    <td width="42">
                                                        <div align="center"><strong>TT</strong></div>
                                                    </td>
                                                    <td width="150px">
                                                        <div align="center"><strong>Họ tên</strong></div>
                                                    </td>

                                                    <td width="500px">
                                                        <div align="center"><strong>Thông tin Bị cáo, Tội danh, mức án</strong></div>
                                                    </td>
                                                    <td width="70px">
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
                                                                <asp:Literal ID="lttTenDS" runat="server"></asp:Literal></td>
                                                       
                                                            <td>
                                                                 <%#String.IsNullOrEmpty(Eval("Hs_MucAn") +"")?"":("Mức án:"+Eval("Hs_MucAn")+"") %>
                                                                <br />
                                                                 <%#String.IsNullOrEmpty(Eval("HS_TenToiDanh") +"")?"":("Tội danh:"+Eval("HS_TenToiDanh")+"") %>
                                                            </td>
                                                                                                               
                                                            <td>
                                                                <div id="td_sua_div" runat="server" align="center">
                                                                    <asp:LinkButton ID="lkSua" runat="server"
                                                                        Text="Sửa" ForeColor="#0e7eee"
                                                                        CommandName="Sua" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                    &nbsp;&nbsp;
                                                                        <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                                                            Text="Xóa" ForeColor="#0e7eee"
                                                                            CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                            OnClientClick="return confirm('Bạn thực sự muốn xóa Bị cáo này? ');"></asp:LinkButton>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                </asp:Repeater>


                                            </table>
                                        </td>
                                    </tr>
                                    <!----------------------------------------->

                                </table>
                            </div>
                        </div>
                    </asp:Panel>

                    <!---------------------------->
                    <asp:Panel ID="pnHoSoVKS" runat="server">
                        <div style="float: left; margin-bottom: 10px; width: 100%; position: relative; margin-top: 10px;">
                            <h4 class="tleboxchung">4. Hồ sơ kháng nghị của VKS</h4>
                            <div class="boder" style="padding: 2%; width: 96%;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 110px;">Số<span class="batbuoc">*</span></td>
                                        <td style="width: 255px;">
                                            <asp:TextBox ID="txtVKS_So" CssClass="user" runat="server"
                                                onkeypress="return isNumber(event)"
                                                Width="242px"></asp:TextBox>

                                        </td>
                                        <td style="width: 110px;">Ngày<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtVKS_Ngay" CssClass="user" runat="server"
                                                Width="110px" AutoPostBack="true" OnTextChanged="txtVKS_Ngay_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtVKS_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtVKS_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

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
                    <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                        <h4 class="tleboxchung">5. Thông tin thụ lý xét xử GĐT,TT</h4>
                        <div class="boder" style="padding: 2%; width: 96%;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 110px;">Ngày VKS trả/chuyển HS</td>
                                    <td style="width: 255px;">
                                        <asp:TextBox ID="txtNgayVKSTraHS" CssClass="user" runat="server"
                                            onkeypress="return isNumber(event)"
                                            Width="242px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayVKSTraHS" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayVKSTraHS" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                    <td style="width: 110px;"></td>
                                    <td></td>
                                </tr>
                               <%-- <tr>
                                    <td>Số KN của VKS</td>
                                    <td>
                                        <asp:TextBox ID="txtKNVKS_So" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                    </td>
                                    <td>Ngày KN</td>
                                    <td>
                                        <asp:TextBox ID="txtKNVKS_Ngay" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtKNVKS_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtKNVKS_Ngay" Mask="99/99/9999"
                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>--%>
                                <tr>
                                    <td>Số thụ lý GĐT</td>
                                    <td>
                                        <asp:TextBox ID="txtSoThuLy" CssClass="user" runat="server"
                                            Width="242px"></asp:TextBox>
                                    </td>
                                    <td>Ngày thụ lý GĐT<span class="batbuoc">*</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayThuLy" CssClass="user" runat="server"
                                            Width="110px" AutoPostBack="true" OnTextChanged="txtNgayThuLy_TextChanged"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayThuLy" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayThuLy" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:Button ID="cmdUpdateTTXX" runat="server" CssClass="buttoninput"
                                            Text="Lưu" OnClick="cmdUpdateTTXX_Click" OnClientClick="return validate_ttxx();" />
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
                    <!---------------------------->
                </div>
                <div style="margin: 5px; text-align: center; width: 95%;">
                    <div style="display: none;">
                        <asp:Button ID="cmdUpdate2" runat="server" CssClass="buttoninput" Text="Lưu"
                            OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                        
                        <asp:Button ID="cmdLamMoi2" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLamMoi_Click" />
                    </div>
                    <asp:Button ID="cmdQuaylai2" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>
                <div style="margin: 5px; width: 95%; color: red;">
                    <asp:Label ID="lttMsg" runat="server"></asp:Label>
                </div>
            </div>
        </div>
    </div>
    <script>
        function validate() {
            
            if (!validate_banan_qd())
                return false;
            return true;
        }
        
        function validate_banan_qd() {
            var value_change = "";
            var txtSoBA = document.getElementById('<%=txtSoBA.ClientID%>');
            if (!Common_CheckTextBox(txtSoBA, 'Số BA/QĐ'))
                return false;

            //-----------------------------
            var txtNgayThuLy = document.getElementById('<%=txtNgayThuLy.ClientID%>');

            var txtNgayBA = document.getElementById('<%=txtNgayBA.ClientID%>');
            if (!CheckDateTimeControl(txtNgayBA, "Ngày BA/QĐ"))
                return false;
            //-----------------------------
            var dropToaAn = document.getElementById('<%=dropToaAn.ClientID%>');
            value_change = dropToaAn.options[dropToaAn.selectedIndex].value;
            if (value_change == "0") {
                alert("Bạn chưa chọn Tòa án thụ lý vụ việc. Hãy kiểm tra lại!");
                dropToaAn.focus();
                return false;
            }
            //-----------------------------

            return true;
        }

        function validateDS() {

            //-----------------------------
            var dropQHPL = document.getElementById('<%=dropQHPL.ClientID%>');
            value_change = dropQHPL.options[dropQHPL.selectedIndex].value;
            if (value_change == "0") {
                alert("Bạn chưa chọn 'Quan hệ pháp luật'. Hãy kiểm tra lại!");
                dropQHPL.focus();
                return false;
            }
           
            //----------------------------
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
