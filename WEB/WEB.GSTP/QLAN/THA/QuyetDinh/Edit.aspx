<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.QuyetDinh.Edit" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%-- <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>--%>
    <script src="../../../UI/js/Common.js"></script>
    <style>
        .boxchung {
            float: left;
            width: 99%;
            margin-left: 0;
        }
    </style>
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddCurrentID" Value="0" runat="server" />
    <asp:HiddenField ID="hddBiAnID" Value="0" runat="server" />
    <asp:HiddenField ID="hddVuAnID" Value="0" runat="server" />
    <asp:HiddenField ID="hddHinhPhatChange" runat="server" Value="0" />
    <asp:HiddenField ID="hddGroupChange" runat="server" Value="0" />
    <div class="box">
        <div class="box_nd">
            <asp:Panel ID="pn" runat="server">
                <div class="truong">
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;" >
                        <asp:Literal ID="lstMsgTop" runat="server"></asp:Literal>
                    </div>
                    <div style="margin: 5px; text-align: center; width: 95%">
                        <asp:Button ID="cmdSave" runat="server" CssClass="buttoninput" Text="Lưu"
                            OnClientClick="return validate();"   OnClick="cmdSave_Click"/>
                        <asp:Button ID="cmdXoaQD" runat="server" CssClass="buttoninput" 
                            Text="Xóa Quyết định THA" OnClick="cmdXoaQD_Click"/>
                        <asp:Button ID="cmdQuaylaiB" runat="server" CssClass="buttoninput"
                            Text="Quay lại" OnClick="cmdQuaylai_Click" />
                    </div>
                    <div style="width: 100%; float: left;">
                        <asp:Label runat="server" ID="lbthongbaoA" ForeColor="Red"></asp:Label>
                    </div>
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_green">Quyết định thi hành án</h4>
                        <div class="boder" style="padding: 20px 10px;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 95px;">Bị án<span class="batbuoc">(*)</span></td>
                                    <td style="width: 200px;">
                                        <asp:DropDownList ID="dropBiAn" CssClass="chosen-select"
                                            runat="server" Width="200px">
                                        </asp:DropDownList>

                                    </td>
                                    <td style="width: 100px;">Số quyết định<span class="batbuoc">(*)</span></td>
                                    <td style="width: 200px;">
                                        <asp:TextBox ID="txtSoQD" CssClass="user"
                                            runat="server" Width="200px"></asp:TextBox></td>
                                    <td style="width: 110px;">
                                        <div class="float_right">Ngày quyết định<span class="batbuoc">(*)</span></div>
                                    </td>
                                    <td style="width: 100px;">
                                        <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user float_left"
                                            Width="100px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server"
                                            TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server"
                                            TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 95px;">Tình trạng bị án<span class="batbuoc">(*)</span></td>
                                    <td style="width: 200px;">
                                            <asp:DropDownList ID="dropTTBiAn" CssClass="chosen-select"
                                                runat="server" Width="200px" OnSelectedIndexChanged="dropTTBiAn_SelectedIndexChanged" AutoPostBack="True">
                                            </asp:DropDownList>

                                     </td>
                                    <asp:Panel ID="pnNoiTamGiam" runat="server" Visible="false">
                                        <td>Nơi tạm giam<asp:Panel id="pnRequireNoiTamGiam" runat="server"><span class="batbuoc">(*)</span></asp:Panel></td>
                                        <td colspan="1">
                                            <asp:TextBox ID="txtNoiTamGiam" CssClass="user"
                                                runat="server" Width="98%"></asp:TextBox>
                                        </td>
                                    </asp:Panel>
                                </tr>
                                <tr>
                                    <asp:Panel ID="pnThoiGianTTBian" runat="server" Visible="false">
                                        <td>Từ ngày</td>
                                        <td>
                                            <asp:TextBox ID="txtTTTuNgay" runat="server" CssClass="user"
                                                Width="192px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server"
                                                TargetControlID="txtTTTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                                                TargetControlID="txtTTTuNgay" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN"
                                                ErrorTooltipEnabled="true" />
                                        </td>
                                         <td>Đến ngày</td>
                                        <td>
                                            <asp:TextBox ID="txtTTDenNgay" runat="server" CssClass="user"
                                                Width="200px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server"
                                                TargetControlID="txtTTDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server"
                                                TargetControlID="txtTTDenNgay" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN"
                                                ErrorTooltipEnabled="true" />
                                        </td>
                                    </asp:Panel>
                                    <asp:Panel ID="pnQDTruyNa" runat="server" Visible="false">
                                        <td>Số QĐ truy nã <span class="batbuoc">(*)</span></td>
                                        <td colspan="1">
                                            <asp:TextBox ID="txtSoQDTruyNa" CssClass="user" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                        <td>Ngày QĐ truy nã<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayQDTruyNa" runat="server" CssClass="user"
                                                Width="200px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server"
                                                TargetControlID="txtNgayQDTruyNa" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server"
                                                TargetControlID="txtNgayQDTruyNa" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN"
                                                ErrorTooltipEnabled="true" />
                                        </td>
                                    </asp:Panel>
                                </tr>
                                <tr>
                                    <asp:Panel ID="pnApGiai" runat="server" Visible="false">
                                        <td>Số lệnh áp giải<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtSoLenhAPGiai" CssClass="user" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                        <td>Ngày lệnh áp giải<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayLenhApGiai" runat="server" CssClass="user"
                                                Width="200px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender6" runat="server"
                                                TargetControlID="txtNgayLenhApGiai" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server"
                                                TargetControlID="txtNgayLenhApGiai" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN"
                                                ErrorTooltipEnabled="true" />
                                        </td>
                                    </asp:Panel>
                                </tr>
                                <tr>
                                    <td>Ngày thi hành <asp:Panel id="requireNgayThiHanh" runat="server"><span class="batbuoc">(*)</span></asp:Panel></td>
                                    <%--<td>Ngày thi hành<span class="batbuoc">(*)</span></td>--%>
                                    <td>
                                        <asp:TextBox ID="txtNgayTHA" runat="server" CssClass="user"
                                            Width="192px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                            TargetControlID="txtNgayTHA" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                            TargetControlID="txtNgayTHA" Mask="99/99/9999"
                                            MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                    </td>
                                    <td>Nơi chấp hành án</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtNoiChapHanhAn" CssClass="user"
                                            runat="server" Width="98%"></asp:TextBox>
                                    </td>
                                    
                                </tr>
                                <tr>
                                    <td>Người ký<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="dropNguoiKy" CssClass="chosen-select" AutoPostBack="true"
                                            runat="server" Width="200px" OnSelectedIndexChanged="dropNguoiKy_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                     <td>Chức vụ<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtChucVu" CssClass="user" Enabled="false" AutoPostBack="true"
                                            runat="server" Width="200px"></asp:TextBox></td>
                                </tr>
                                <tr> 
                                    <td>Tệp đính kèm</td>
                                    <td colspan="5">
                                        <asp:HiddenField ID="hddFilePath" runat="server" />                                
                                        <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                        <asp:HiddenField ID="hddSessionID" runat="server" />
                                        <asp:HiddenField ID="hddURLKS" runat="server" />
                                        <!------------------------>
                                        <div id="zonekyso" style="margin-bottom: 5px; margin-top: 10px;">
                                            <asp:FileUpload ID="fileupload" runat="server" onchange="fileSelected()" style="display:none"/>
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                    ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                            <asp:LinkButton ID="lkFile" runat="server"
                                                ToolTip="Bấm vào để tải file" OnClick="lkFile_Click"></asp:LinkButton>  
                                           <asp:ImageButton ID="cmdXoa" runat="server"
                                                ImageUrl="../../../UI/img/delete.png" ToolTip="Xóa"
                                                OnClientClick="return confirm('Bạn có thực sự muốn xóa tệp đính kèm này?');"
                                                Width="20px" OnClick="cmdXoa_Click" Visible="false"></asp:ImageButton>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <asp:Panel ID="pnHinhPhat" runat="server">
                    <!----------------------------------------->
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_green">
                            <asp:Literal ID="lttNhomHPChinh" runat="server"></asp:Literal></h4>
                        <div class="boder" style="padding: 20px 10px;">
                            <asp:Repeater ID="rptHPChinh" runat="server"
                                OnItemDataBound="rptHP_ItemDataBound">
                                <HeaderTemplate>
                                    <table style="width: 100%;" id="tblHP">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td style="width: 50px;">
                                            <div style="float: left; width: 100%; text-align: center;">
                                                <asp:CheckBox ID="chk"  ToolTip='<%#Eval("HinhPhatID") %>' runat="server" OnCheckedChanged="chk_CheckedChanged"/>
                                            </div>
                                            <asp:HiddenField ID="hddGroup" runat="server" Value='<%#Eval("NHOMHINHPHAT") %>' />
                                            <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("LoaiHinhPHat") %>' />
                                            <asp:HiddenField ID="hddHinhPhatID" runat="server" Value='<%#Eval("HinhPhatID") %>' />
                                        </td>
                                        <td style="width: 50%;"><%# Eval("TenHinhPhat") %></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdDefaultTrue" runat="server"
                                                RepeatDirection="Horizontal" Visible="false">
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                            <!-------------------------->
                                            <asp:RadioButtonList ID="rdTrueFalse" runat="server"
                                                RepeatDirection="Horizontal" Visible="false">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                            <!-------------------------->
                                            <asp:TextBox ID="txtSohoc" CssClass="user" Width="100px"
                                                runat="server" onkeypress="return isNumber(event)" Visible="false"></asp:TextBox>
                                            <!-------------------------->
                                            <asp:Panel ID="pnThoiGian" runat="server" Visible="false">
                                                <asp:TextBox ID="txtNam" CssClass="user align_right" Width="40px"
                                                    runat="server"
                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                <span class='span_date'>năm&nbsp;&nbsp;</span>
                                                <asp:TextBox ID="txtThang" CssClass="user align_right" Width="40px" runat="server"
                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                <span class='span_date'>tháng&nbsp;&nbsp;</span>
                                                <asp:TextBox ID="txtNgay" CssClass="user align_right" Width="40px" runat="server"
                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                <span class='span_date'>ngày</span>
                                            </asp:Panel>
                                            <!-------------------------->
                                            <asp:Panel ID="pnKhac" runat="server" Visible="false">
                                                <asp:TextBox ID="txtKhac1" CssClass="user" Width="100px" runat="server"
                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                hoặc
                                                                    <asp:TextBox ID="txtKhac2" runat="server" CssClass="user"
                                                                        Width="100px" Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                            </asp:Panel>

                                            <!-------------------------->
                                            <asp:CheckBox ID="chkAnTreo" runat="server"
                                                Text="Hưởng án treo" CssClass="margin_top" AutoPostBack="true" OnCheckedChanged="chkAnTreo_CheckedChanged" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td>
                                            <asp:Panel ID="pnCoQuanGiamSat" runat="server" Visible="false">
		                                        <asp:Label ID="lblCoQuanGiamSat" runat="server">Cơ quan Giám sát, giáo dục<span class="batbuoc">(*)</span></asp:Label>
		                                        <asp:TextBox ID="txtCoQuanGiamSat" CssClass="user" runat="server" Width="200px"></asp:TextBox>
	                                        </asp:Panel>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate></table></FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    <!---------------------------------------->
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_green">
                            <asp:Literal ID="lttNhomHPBoSung" runat="server"></asp:Literal></h4>
                        <div class="boder" style="padding: 20px 10px;">
                            <asp:Repeater ID="rptHPBoSung" runat="server" OnItemDataBound="rptHP_ItemDataBound">
                                <HeaderTemplate>
                                    <table width="100%" id="tblHP">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td style="width: 50px;">
                                            <div style="float: left; width: 100%; text-align: center;">
                                                <asp:CheckBox ID="chk"   ToolTip='<%#Eval("HinhPhatID") %>' runat="server" Visible="false" OnCheckedChanged="chk_CheckedChanged"/>
                                                <%-- <img src="../../../UI/img/arrow.png" />--%>
                                            </div>
                                            <asp:HiddenField ID="hddGroup" runat="server" Value='<%#Eval("NHOMHINHPHAT") %>' />
                                            <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("LoaiHinhPHat") %>' />
                                            <asp:HiddenField ID="hddHinhPhatID" runat="server" Value='<%#Eval("HinhPhatID") %>' />
                                        </td>
                                        <td style="width: 50%;"><%# Eval("TenHinhPhat") %></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdDefaultTrue" runat="server"
                                                RepeatDirection="Horizontal" Visible="false">
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                            <!-------------------------->
                                            <asp:RadioButtonList ID="rdTrueFalse" runat="server"
                                                RepeatDirection="Horizontal" Visible="false">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                            <!-------------------------->
                                            <asp:TextBox ID="txtSohoc" CssClass="user" Width="100px"
                                                runat="server" onkeypress="return isNumber(event)" Visible="false"></asp:TextBox>
                                            <!-------------------------->
                                            <asp:Panel ID="pnThoiGian" runat="server" Visible="false">
                                                <asp:TextBox ID="txtNam" CssClass="user align_right" Width="40px" runat="server"
                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                <span class='span_date'>năm&nbsp;&nbsp;</span>
                                                <asp:TextBox ID="txtThang" CssClass="user align_right" Width="40px" runat="server"
                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                <span class='span_date'>tháng&nbsp;&nbsp;</span>
                                                <asp:TextBox ID="txtNgay" CssClass="user align_right" Width="40px" runat="server"
                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                <span class='span_date'>ngày</span>
                                            </asp:Panel>
                                            <!-------------------------->
                                            <asp:Panel ID="pnKhac" runat="server" Visible="false">
                                                <asp:TextBox ID="txtKhac1" CssClass="user" Width="100px" runat="server"
                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                hoặc
                                                                    <asp:TextBox ID="txtKhac2" runat="server" CssClass="user"
                                                                        Width="100px" Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                            </asp:Panel>
                                            <!-------------------------->

                                            <asp:CheckBox ID="chkAnTreo" runat="server" Text="Hưởng án treo" CssClass="margin_top" 
                                                AutoPostBack="true" OnCheckedChanged="chkAnTreo_CheckedChanged" />
                                            <asp:Panel ID="pnCoQuanGiamSat" runat="server" Visible="false">
		                                        <asp:Label ID="lblCoQuanGiamSat" runat="server">Cơ quan Giám sát, giáo dục<span class="batbuoc">(*)</span></asp:Label>
		                                        <asp:TextBox ID="txtCoQuanGiamSat" CssClass="user" runat="server" Width="100px"></asp:TextBox>
	                                        </asp:Panel>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate></table></FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    <!------------------------------------------->
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_green">
                            <asp:Literal ID="lttNhomQDKhac" runat="server"></asp:Literal></h4>
                        <div class="boder" style="padding: 20px 10px;">
                            <asp:Repeater ID="rptQDKhac" runat="server" OnItemDataBound="rptHP_ItemDataBound">
                                <HeaderTemplate>
                                    <table width="100%" id="tblHP">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td style="width: 50px;">
                                            <div style="float: left; width: 100%; text-align: center;">
                                                <asp:CheckBox ID="chk"  ToolTip='<%#Eval("HinhPhatID") %>' runat="server" OnCheckedChanged="chk_CheckedChanged"/>
                                            </div>
                                            <asp:HiddenField ID="hddGroup" runat="server" Value='<%#Eval("NHOMHINHPHAT") %>' />
                                            <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("LoaiHinhPHat") %>' />
                                            <asp:HiddenField ID="hddHinhPhatID" runat="server" Value='<%#Eval("HinhPhatID") %>' />
                                        </td>
                                        <td style="width: 50%;"><%# Eval("TenHinhPhat") %></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdDefaultTrue" runat="server"
                                                RepeatDirection="Horizontal" Visible="false">
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                            <!-------------------------->
                                            <asp:RadioButtonList ID="rdTrueFalse" runat="server"
                                                RepeatDirection="Horizontal" Visible="false">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                            <!-------------------------->
                                            <asp:TextBox ID="txtSohoc" CssClass="user" Width="100px"
                                                runat="server" onkeypress="return isNumber(event)" Visible="false"></asp:TextBox>
                                            <!-------------------------->
                                            <asp:Panel ID="pnThoiGian" runat="server" Visible="false">
                                                <asp:TextBox ID="txtNam" CssClass="user align_right" Width="40px" runat="server"
                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                <span class='span_date'>năm&nbsp;&nbsp;</span>
                                                <asp:TextBox ID="txtThang" CssClass="user align_right" Width="40px" runat="server"
                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                <span class='span_date'>tháng&nbsp;&nbsp;</span>
                                                <asp:TextBox ID="txtNgay" CssClass="user align_right" Width="40px" runat="server"
                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                <span class='span_date'>ngày</span>
                                            </asp:Panel>
                                            <!-------------------------->
                                            <asp:Panel ID="pnKhac" runat="server" Visible="false">
                                                <asp:TextBox ID="txtKhac1" CssClass="user" Width="100px" runat="server"
                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                hoặc
                                                                    <asp:TextBox ID="txtKhac2" runat="server" CssClass="user"
                                                                        Width="100px" Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                            </asp:Panel>
                                            <!-------------------------->
                                            <asp:CheckBox ID="chkAnTreo" runat="server" Text="Hưởng án treo" CssClass="margin_top" 
                                                AutoPostBack="true" OnCheckedChanged="chkAnTreo_CheckedChanged" />
                                            <asp:Panel ID="pnCoQuanGiamSat" runat="server" Visible="false">
		                                        <asp:Label ID="lblCoQuanGiamSat" runat="server">Cơ quan Giám sát, giáo dục<span class="batbuoc">(*)</span></asp:Label>
		                                        <asp:TextBox ID="txtCoQuanGiamSat" CssClass="user" runat="server" Width="100px"></asp:TextBox>
	                                        </asp:Panel>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate></table></FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    <!------------------------------------------>
                    </asp:Panel>
                    <asp:Panel ID="pnAnPhi" runat="server">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Quyết định và hình phạt</h4>
                            <div class="boder" style="padding: 10px;">
                                <div class="zone_ghichu" style="display: none;">
                                    <b>Ghi chú</b><br />
                                    <b>1. Lưu án phí cho bị cáo</b><br />
                                    1.1. Nhập mức án phí cho bị cáo<br />
                                    1.2. Ấn chọn "Lưu" để cập nhật thông tin<br />
                                    <b>2. Cập nhật quyết định & điều luật áp dụng cho bị cáo</b><br />
                                    2.1. Chọn bị cáo<br />
                                    2.2. Chọn "Điều luật áp dụng" của bị cáo được chọn<br />
                                </div>
                                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                    <asp:Literal ID="lttMsgAnPhi" runat="server"></asp:Literal>
                                </div>
                                <div style="">
                                    <asp:Panel runat="server" ID="pndata">

                                        <asp:Repeater ID="rpt" runat="server"
                                            OnItemCommand="rpt_ItemCommand"
                                            OnItemDataBound="rpt_ItemDataBound">
                                            <HeaderTemplate>
                                                <table class="table2" width="100%" border="1">
                                                    <tr class="header">
                                                        <td style="width: 42px;">
                                                            <div align="center"><strong>TT</strong></div>
                                                        </td>
                                                        <td width="20%">
                                                            <div align="center"><strong>Bị cáo</strong></div>
                                                        </td>
                                                        <td width="80px">
                                                            <div align="center"><strong>Tham gia phiên tòa</strong></div>
                                                        </td>
                                                        <td width="60px">
                                                            <div align="center"><strong>Án phí (Đơn vị là đồng)</strong></div>
                                                        </td>

                                                        <td width="100px">
                                                            <div align="center"><strong>Ngày nhận bản án</strong></div>
                                                        </td>
                                                        <td width="90px">
                                                            <div align="center"><strong>Hình phạt tổng hợp</strong></div>
                                                        </td>
                                                        <td>
                                                            <div align="center"><strong>Điều luật áp dụng</strong></div>
                                                        </td>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td>
                                                        <asp:HiddenField ID="hddBiCao" runat="server" Value='<%#Eval("ID") %>' />
                                                        <%# Eval("STT") %></td>
                                                    <td><%#Eval("HoTen") %></td>
                                                    <td>
                                                        <div style="text-align: center;">
                                                            <asp:CheckBox ID="chkThamGiaPhienToa" runat="server"
                                                                Checked='<%# (Convert.ToInt16(Eval("IsThamGiaPhienToa"))>0)? true:false %>' />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtAnPhi" runat="server" Text='<%#Eval("AnPhi") %>'
                                                            onkeyup="javascript:this.value=Comma(this.value);" onkeypress="return isNumber(event)"
                                                            CssClass="user align_right"></asp:TextBox></div>
                                                    </td>

                                                    <td>
                                                        <div style="text-align: center;">
                                                            <asp:TextBox ID="txtNgaynhanbanan" runat="server"
                                                                Text='<%# string.Format("{0:dd/MM/yyyy}",Eval("NgayNhanBanAn")) %>' CssClass="user" Width="70px"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="txtNgaynhanbanan_CalendarExtender" runat="server" TargetControlID="txtNgaynhanbanan" Format="dd/MM/yyyy" />
                                                            <cc1:MaskedEditExtender ID="txtNgaynhanbanan_MaskedEditExtender3" runat="server" TargetControlID="txtNgaynhanbanan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div style="text-align: center;">
                                                            <asp:Label ID="lblTHtoidanh" runat="server" Text=""></asp:Label>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <asp:Panel ID="lnLinkToiDanh" runat="server">
                                                            <div align="center">
                                                                <a href="javascript:;" onclick="popupChonToiDanh(<%#Eval("ID") %>)" class="link_ds">Điều luật áp dụng</a>
                                                            </div>
                                                        </asp:Panel>
                                                    </td>
                                                    <td style="display: none;">
                                                        <asp:HiddenField ID="hddToaGiaiQuyetID" runat="server" Value='<%#Eval("TOA_GIAIQUYET_ID") %>' />
                                                    </td>
                                                </tr>
                                            </ItemTemplate>

                                            <FooterTemplate></table></FooterTemplate>
                                        </asp:Repeater>
                                        <asp:Button ID="cmdUpdateAnPhi" runat="server" CssClass="buttoninput"
                                                    Text="Lưu thông tin" OnClick="cmdUpdateAnPhi_Click" />
                                        <asp:Button ID="cmdReloadParent" runat="server" CssClass="buttoninput" Style="display: none" OnClick="cmdReloadParent_Click" />
                                    </asp:Panel>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnAnPhiPT" runat="server">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Quyết định & điều luật</h4>
                            <div class="boder" style="padding: 10px;">

                                <div class="zone_ghichu" style="display: none;">
                                    <b>Ghi chú</b><br />
                                    <b>1. Lưu án phí cho bị cáo</b><br />
                                    1.1. Nhập mức án phí cho bị cáo<br />
                                    1.2. Ấn chọn "Lưu" để cập nhật thông tin<br />
                                    <b>2. Cập nhật quyết định & điều luật áp dụng cho bị cáo</b><br />
                                    2.1. Chọn bị cáo
                            <br />
                                    2.2. Chọn "Điều luật áp dụng" của bị cáo được chọn<br />
                                </div>
                                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                    <asp:Literal ID="lttMsgAnPhiPT" runat="server"></asp:Literal>
                                </div>
                                <div style="">

                                    <asp:Repeater ID="rptPT" runat="server" OnItemDataBound="rptPT_ItemDataBound">
                                        <HeaderTemplate>
                                            <table class="table2" width="100%" border="1">
                                                <tr class="header">
                                                    <td width="20px">
                                                        <div align="center"><strong>TT</strong></div>
                                                    </td>
                                                    <td>
                                                        <div align="center"><strong>Bị cáo - Tội danh</strong></div>
                                                    </td>
                                                    <td width="150px">
                                                        <div align="center"><strong>Quyết định sơ thẩm</strong></div>
                                                    </td>
                                                    <td width="130px">
                                                        <div align="center"><strong>Yêu cầu kháng cáo/ kháng nghị</strong></div>
                                                    </td>
                                                    <td width="150px">
                                                        <div align="center"><strong>Quyết định phúc thẩm</strong></div>
                                                    </td>
                                                    <td width="110px">
                                                        <div align="center"><strong>Tham gia phiên tòa</strong></div>
                                                    </td>
                                                    <td width="30px">
                                                        <div align="center"><strong>Án phí (Đơn vị là đồng)</strong></div>
                                                    </td>
                                                    <td width="110px">
                                                        <div align="center"><strong>Ngày nhận bản án</strong></div>
                                                    </td>
                                                    <td width="130px">
                                                        <div align="center"><strong>Điều luật áp dụng</strong></div>
                                                    </td>
                                                </tr>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <asp:HiddenField ID="hddBiCaoPT" runat="server" Value='<%#Eval("BiCanID") %>' />
                                                    <%# Eval("STT") %></td>
                                                <td><%#Eval("HoTen") %> - <%#Eval("getalltoidanh") %></td>
                                                <td>
                                                    <div align="center">
                                                        <asp:Label ID="lblTHtoidanhST" runat="server" Text=""></asp:Label>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div align="center">
                                                        <asp:Label ID="lbNoiDung_KCKN" runat="server" Text=""> <%#Eval("NoiDung_KCKN") %></asp:Label>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div align="center">
                                                        <asp:Label ID="lblTHtoidanhPT" runat="server" Text=""></asp:Label>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="text-align: center;">
                                                        <asp:CheckBox ID="chkThamGiaPhienToaPT" runat="server"
                                                            Checked='<%# (Convert.ToInt16(Eval("IsThamGiaPhienToa"))>0)? true:false %>' />
                                                    </div>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtAnPhiPT" runat="server" Text='<%#Eval("AnPhi") %>' onkeypress="return isNumber(event)" CssClass="user align_right"></asp:TextBox></div>
                                                </td>
                                                <td>
                                                    <div style="text-align: center;">
                                                        <asp:TextBox ID="txtNgaynhanbananPT" runat="server" Text='<%# string.Format("{0:dd/MM/yyyy}",Eval("NgayNhanBanAn")) %>' CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtNgaynhanbanan_CalendarExtender" runat="server" TargetControlID="txtNgaynhanbananPT" Format="dd/MM/yyyy" />
                                                        <cc1:MaskedEditExtender ID="txtNgaynhanbanan_MaskedEditExtender3" runat="server" TargetControlID="txtNgaynhanbananPT" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True"
                                                            Century="2000" CultureAMPMPlaceholder=""
                                                            CultureCurrencySymbolPlaceholder="₫"
                                                            CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                                    </div>
                                                </td>
                                                <td>
                                                    <div align="center">
                                                        <asp:Panel ID="lnLinkToiDanhPT" runat="server">
                                                            <a href="javascript:;" class="link_ds"
                                                                onclick="popupChonToiDanhPT(<%#Eval("BiCanID") %>)">Điều luật áp dụng</a>
                                                        </asp:Panel>
                                                    </div>
                                                </td>
                                                <td style="display: none;">
                                                    <asp:HiddenField ID="hddToaGiaiQuyetIDPT" runat="server" Value='<%#Eval("TOA_GIAIQUYET_ID") %>' />
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate></table></FooterTemplate>
                                    </asp:Repeater>

                                    <div class="phantrang_bottom">
                                        <div class="sobanghi">
                                            <asp:Button ID="cmdPTSave2" runat="server" CssClass="buttoninput"
                                                Text="Lưu án phí" OnClick="cmdPTSave_Click" />
                                            <asp:Button ID="cmdReloadParentPT" runat="server" CssClass="buttoninput" Style="display: none" OnClick="cmdReloadParentPT_Click" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                    <!------------------------------------------->
                    <asp:Panel ID="pnThongTinGiamGiu" runat="server">
                    <div class="boxchung">
                        <div class="boder" style="padding: 20px 10px;">
                             <table class="table1">
                                <tr>
                                    <td style="width: 150px;">Số TB của trại giam</td>
                                    <td style="width: 200px;">
                                        <asp:TextBox ID="txtSTBTraiGiam" CssClass="user"
                                            runat="server" Width="100px"></asp:TextBox>
                                    </td>
                                    <td style="width: 150px;">Ngày TB của trại giam</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayTBTraiGiam" runat="server" CssClass="user float_left"
                                            Width="200px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender7" runat="server"
                                            TargetControlID="txtNgayTBTraiGiam" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server"
                                            TargetControlID="txtNgayTBTraiGiam" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 150px;">Thông tin trại giam</td>
                                    <td colspan="3"  style="width: 200px;">
                                        <asp:TextBox ID="txtThongTinTraiGiam" CssClass="user"
                                            runat="server" Width="98%"></asp:TextBox>

                                    </td>
                                </tr>
                                 <tr>
                                    <td style="width: 150px;">Số giấy báo tử</td>
                                    <td style="width: 200px;">
                                        <asp:TextBox ID="txtSoGiayBaoTu" CssClass="user"
                                            runat="server" Width="100px"></asp:TextBox>
                                    </td>
                                    <td style="width: 150px;">Ngày giấy báo tử</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayGiayBaoTu" runat="server" CssClass="user float_left"
                                            Width="200px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender8" runat="server"
                                            TargetControlID="txtNgayGiayBaoTu" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server"
                                            TargetControlID="txtNgayGiayBaoTu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                                 <tr>
                                    <td style="width: 150px;">Nơi cấp giấy</td>
                                    <td colspan="3"  style="width: 200px;">
                                        <asp:TextBox ID="txtNoiCapGiay" CssClass="user"
                                            runat="server" Width="98%"></asp:TextBox>

                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    </asp:Panel>
                    <!------------------------------------------>
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                        <asp:Literal ID="lstMsgBottom" runat="server"></asp:Literal>
                    </div>
                    <div style="margin: 5px; text-align: center; width: 95%">
                        <asp:Button ID="cmdSave2" runat="server" CssClass="buttoninput" Text="Lưu"
                            OnClientClick="return validate();" OnClick="cmdSave_Click"/>
                        <asp:Button ID="cmdQuaylai2" runat="server" CssClass="buttoninput"
                            Text="Quay lại" OnClick="cmdQuaylai_Click" />
                    </div>
                </div>
                
            </asp:Panel>
             <div style="width: 100%; float: left;">
                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
            </div>
        </div>
    </div>
    
    <script>
          function pageLoad(sender, args) {
              var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
              for (var selector in config) { $(selector).chosen(config[selector]); }
          }
          //-------------------------------------
          function validate() {
              var NgaySoSanh = '<%= NgaySoSanh%>';

            var txtSoQD = document.getElementById('<%=txtSoQD.ClientID%>');
            if (!Common_CheckTextBox(txtSoQD, "Số quyết định"))
                return false;
           
            //-----------------------------
            var txtNgayQD = document.getElementById('<%=txtNgayQD.ClientID%>');
            if (!CheckDateTimeControl(txtNgayQD, 'Ngày quyết định'))
                return false;

            if (!SoSanh2Date(txtNgayQD,'Ngày quyết định thi hành án', NgaySoSanh, 'Ngày thụ lý'))
                return false;
            //-----------------------------

              var txtTinhTrangBiAn = document.getElementById('<%=dropTTBiAn.ClientID%>');
              console.log("txtTinhTrangBiAn element: " + txtTinhTrangBiAn);
              var valueTxtTinhTrangBiAn = txtTinhTrangBiAn.options[txtTinhTrangBiAn.selectedIndex].value;
              console.log("txtTinhTrangBiAn value: " + valueTxtTinhTrangBiAn);
              if (valueTxtTinhTrangBiAn == "0") {
                  alert('Vui lòng chọn tình trạng bị án!');
                  txtTinhTrangBiAn.focus();
                  return false;
              }
              if (valueTxtTinhTrangBiAn == "TTBA_TAM_GIAM") {
                  var txtNgayTHA = document.getElementById('<%=txtNgayTHA.ClientID%>');
                  if (!CheckDateTimeControl(txtNgayTHA, 'Ngày thi hành án'))
                      return false;
                  if (!SoSanh2Date(txtNgayTHA, 'Ngày thi hành án', NgaySoSanh, 'Ngày thụ lý'))
                      return false;

                  var ngay_qd = txtNgayQD.value;
                  if (!SoSanh2Date(txtNgayTHA, 'Ngày thi hành án', ngay_qd, 'Ngày quyết định thi hành án'))
                      return false;
                  var txtNoiTamGiam = document.getElementById('<%=txtNoiTamGiam.ClientID%>');
                  if (txtNoiTamGiam == null || txtNoiTamGiam.value == "") {
                      alert('Vui lòng nhập nơi tạm giam!');
                      txtSoQDTruyNa.focus();
                      return false;
                  }
              }
              if (valueTxtTinhTrangBiAn == "TTBA_BO_TRON") {
                  var txtSoQDTruyNa = document.getElementById('<%=txtSoQDTruyNa.ClientID%>');
                  if (txtSoQDTruyNa == null || txtSoQDTruyNa.value == "") {
                      alert('Vui lòng nhập số quyết định truy nã!');
                      txtSoQDTruyNa.focus();
                      return false;
                  }
                  var txtSoLenhApGiai = document.getElementById('<%=txtSoLenhAPGiai.ClientID%>');
                  if (txtSoLenhApGiai == null || txtSoLenhApGiai.value == "") {
                      alert('Vui lòng nhập số lệnh áp giải!');
                      txtSoLenhApGiai.focus();
                      return false;
                  }
                  var txtNgayQDTruyNa = document.getElementById('<%=txtNgayQDTruyNa.ClientID%>');
                  if (txtNgayQDTruyNa == null || txtNgayQDTruyNa.value == "") {
                      alert('Vui lòng nhập ngày quyết định truy nã!');
                      txtNgayQDTruyNa.focus();
                      return false;
                  }
                  var txtNgayLenhApGiai = document.getElementById('<%=txtNgayLenhApGiai.ClientID%>');
                  if (txtNgayLenhApGiai == null || txtNgayLenhApGiai.value == "") {
                      alert('Vui lòng nhập ngày lệnh áp giải!');
                      txtNgayLenhApGiai.focus();
                      return false;
                  }
              }

            //----------------------------- 
            var dropNguoiKy = document.getElementById('<%=dropNguoiKy.ClientID%>');
            value_change = dropNguoiKy.options[dropNguoiKy.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn Người ký văn bản Quyết định thi hành án . Hãy kiểm tra lại!');
                dropNguoiKy.focus();
                return false;
              }

            var txtChucVu = document.getElementById('<%=txtChucVu.ClientID%>');
            if (!Common_CheckTextBox(txtChucVu, "chức vụ của người ký"))
                return false;
            return true;
          }
          function ChangeHP(hinhphatid, grouphp) {
              var hddGroupChange = document.getElementById('<%=hddGroupChange.ClientID%>');
            var hddHinhPhatChange = document.getElementById('<%=hddHinhPhatChange.ClientID%>');

            var hdd_value = hddHinhPhatChange.value;
            if (hdd_value == hinhphatid) {
                hddHinhPhatChange.value = "0";
                hddGroupChange.value = "0";
            }
            else {
                hddHinhPhatChange.value = hinhphatid;
                hddGroupChange.value = grouphp;
            }
        }
    </script>

    <script type="text/javascript">
        var count_file = 0;
        function VerifyPDFCallBack(rv) {

        }
        function exc_verify_pdf1() {
            var prms = {};
            var hddSession = document.getElementById('<%=hddSessionID.ClientID%>');
            prms["SessionId"] = "";
            prms["FileName"] = document.getElementById("file1").value;

            var json_prms = JSON.stringify(prms);

            vgca_verify_pdf(json_prms, VerifyPDFCallBack);
        }

        function SignFileCallBack1(rv) {
            var received_msg = JSON.parse(rv);
            if (received_msg.Status == 0) {
                var hddFilePath = document.getElementById('<%=hddFilePath.ClientID%>');
                var new_item = document.createElement("li");
                new_item.innerHTML = received_msg.FileName;
                hddFilePath.value = received_msg.FileServer;
                //-------------Them icon xoa file------------------
                var del_item = document.createElement("img");
                del_item.src = '/UI/img/xoa.gif';
                del_item.style.width = "15px";
                del_item.style.margin = "5px 0 0 5px";
                del_item.onclick = function () {
                    if (!confirm('Bạn muốn xóa file này?')) return false;
                    document.getElementById("file_name").removeChild(new_item);
                }
                del_item.style.cursor = 'pointer';
                new_item.appendChild(del_item);

                document.getElementById("file_name").appendChild(new_item);
            } else {
                document.getElementById("_signature").value = received_msg.Message;
            }
        }

        //metadata có kiểu List<KeyValue> 
        //KeyValue là class { string Key; string Value; }
        function exc_sign_file1() {
            var prms = {};
            var scv = [{ "Key": "abc", "Value": "abc" }];
            var hddURLKS = document.getElementById('<%=hddURLKS.ClientID%>');
            prms["FileUploadHandler"] = hddURLKS.value.replace(/^http:\/\//i, window.location.protocol + '//');
            prms["SessionId"] = "";
            prms["FileName"] = "";
            prms["MetaData"] = scv;
            var json_prms = JSON.stringify(prms);
            vgca_sign_file(json_prms, SignFileCallBack1);
        }
        function RequestLicenseCallBack(rv) {
            var received_msg = JSON.parse(rv);
            if (received_msg.Status == 0) {
                document.getElementById("_signature").value = received_msg.LicenseRequest;
            } else {
                alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
            }
        }
       function SetNgayTHA() {
            var NgaySoSanh = '<%= NgaySoSanh%>';
          
            var txtNgayQD = document.getElementById('<%=txtNgayQD.ClientID%>');
            var txtNgayTHA = document.getElementById('<%=txtNgayTHA.ClientID%>');

            if (!CheckDateTimeControl(txtNgayQD, 'Ngày quyết định thi hành án'))
                return false;
            if (!SoSanh2Date(txtNgayQD, 'Ngày quyết định thi hành án', NgaySoSanh, 'Ngày thụ lý'))
                return false;

            if (Common_CheckEmpty(txtNgayQD.value)) 
                txtNgayTHA.value = txtNgayQD.value;
            return true;
        }

    </script>
    <script>
        function fileSelected() {
            // Lấy thông tin về tệp tin được chọn
            var fileInput = document.getElementById('<%=fileupload.ClientID%>');
            var selectedFile = fileInput.files[0]; // Chỉ lấy tệp tin đầu tiên nếu người dùng chọn nhiều tệp tin

            // Thực hiện các xử lý bạn muốn với tệp tin được chọn
            if (selectedFile) {
                console.log('File selected:', selectedFile.name);
                // Thêm mã xử lý khác tại đây
            }
        }

        function popupChonToiDanh(BiCanID) {
            var link = "/QLAN/THA/QuyetDinh/Popup/SoTham/pToiDanh.aspx?aID=" + BiCanID;
             var width = 900;
             var height = 650;
             PopupCenter(link, "Cập nhật điều luật áp dụng cho bị cáo", width, height);
        }

        function popupChonToiDanhPT(BiCanID) {
            var link = "/QLAN/THA/QuyetDinh/Popup/PhucTham/pToiDanh.aspx?aID=" + BiCanID;
             var width = 900;
             var height = 650;
             PopupCenter(link, "Cập nhật điều luật áp dụng cho bị cáo", width, height);
        }

        function Loadds_bicao() {
            $("#<%= cmdReloadParent.ClientID %>").click();
        }
        function Loadds_bicaoPT() {
            $("#<%= cmdReloadParentPT.ClientID %>").click();
        }
    </script>
</asp:Content>
