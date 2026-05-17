<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
 CodeBehind="Tailieu.aspx.cs" Inherits="WEB.GSTP.QLAN.AHC.Hoso.Tailieu" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <style type="text/css">
        .floatF {
            float: left;
        }

        .linkAddFile {
            float: left;
            margin: 6px 0px 0px 10px;
        }

        .TenFile_css {
            color: inherit !important;
        }

        #ContentPlaceHolder1_AsyncFileUpLoad_ctl01 {
            width: 251px !important;
        }

            #ContentPlaceHolder1_AsyncFileUpLoad_ctl01 input[type=text] {
                width: 142px !important;
            }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddNgayNhanDon" Value="" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin tài liệu</h4>
                <div class="boder" style="padding: 10px; float: left; width: 97.5%;">
                    <table class="table1">
                        <tr>
                            <td style="width: 130px;">Ngày bàn giao<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNgayBanGiao" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayBanGiao" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayBanGiao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>Tư cách tố tụng<span class="batbuoc">(*)</span></td>
                            <td>   
                                <asp:RadioButtonList ID="rdbTuCachToTung" runat="server"
                                    RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdbTuCachToTung_SelectedIndexChanged">                                 
                                     <asp:ListItem Value="0" Text="Đương sự"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Người tham gia tố tụng"></asp:ListItem>                      
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr>
                            <td>Người bàn giao<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:DropDownList ID="ddlNguoiBanGiao" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlNguoiBanGiao_SelectedIndexChanged"></asp:DropDownList></td>
                        </tr>

                        <tr>
                            <td>Người nhận<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:DropDownList ID="ddlNguoiNhan" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>Tên tài liệu<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtTenTL" runat="server" Width="242px" CssClass="user"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Tệp đính kèm</td>
                            <td>
                                <asp:HiddenField ID="hddFilePath" runat="server" Value="" />
                                <cc1:AsyncFileUpload ID="AsyncFileUpLoad" CssClass="floatF" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                    ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                <asp:LinkButton ID="lbtAddFile" CssClass="linkAddFile" Visible="false" runat="server" Text="Thêm tệp đính kèm"></asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>&nbsp; &nbsp;</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" 
								OnClientClick="return ValidDataInput();" OnClick="btnUpdate_Click" />
                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    <div style="width: 100%; margin-top: 10px; border-top: 1px solid #c5c5c5; padding-top: 10px;"><b>DANH SÁCH BÀN GIAO</b></div>
                    <asp:HiddenField ID="hddDonID" runat="server" Value="0" />
                    <asp:HiddenField ID="hddID" runat="server" Value="0" />
                    <asp:Panel runat="server" ID="pndata">
                        <div class="phantrang">
                            <div class="sobanghi">
                                <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                            </div>
                            <div class="sotrang">
                                <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                    OnClick="lbTBack_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                    OnClick="lbTNext_Click"></asp:LinkButton>
                            </div>
                        </div>
                        <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                            ItemStyle-CssClass="chan" Width="100%"
                            OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                            <Columns>
                                <asp:TemplateColumn HeaderStyle-Width="25px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>TT</HeaderTemplate>
                                    <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:BoundColumn DataField="TenTaiLieu" HeaderText="Tên tài liệu" HeaderStyle-Width="125px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                <asp:BoundColumn DataField="NGAYBANGIAO" HeaderText="Ngày bàn giao" HeaderStyle-Width="84px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                <asp:BoundColumn DataField="NGUOIBANGIAO" HeaderText="Người giao" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                <asp:BoundColumn DataField="TenLoaiDoiTuong" HeaderText="Tư cách tố tụng" HeaderStyle-Width="135px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                <asp:BoundColumn DataField="NguoiNhan" HeaderText="Người nhận" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                               <%-- <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>' CausesValidation="false" CommandName="Download"
                                            CommandArgument='<%#Eval("ID") %>' CssClass="TenFile_css"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>--%>
                                 <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                    <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                    <ItemTemplate >
                                        <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                            CommandArgument='<%#Eval("ID") %>' ToolTip='<%#Eval("TENFILE")%>' />
                                        <%--<asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>'  CssClass="TenFile_css"></asp:LinkButton>--%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>Thao tác</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                            CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                        &nbsp;&nbsp;
                                        <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" CommandName="Xoa" ForeColor="#0e7eee"
                                            CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                            </Columns>
                            <HeaderStyle CssClass="header"></HeaderStyle>
                            <ItemStyle CssClass="chan"></ItemStyle>
                            <PagerStyle Visible="false"></PagerStyle>
                        </asp:DataGrid>
                        <div class="phantrang">
                            <div class="sobanghi">
                                <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                            </div>
                            <div class="sotrang">
                                <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                    OnClick="lbTBack_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                    OnClick="lbTNext_Click"></asp:LinkButton>
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function ValidDataInput()
		{
			var txtNgayBanGiao = document.getElementById('<%=txtNgayBanGiao.ClientID%>');
			if (!CheckDateTimeControl(txtNgayBanGiao, 'Ngày bàn giao'))
					return false;
			var NgayBanGiao = txtNgayBanGiao.value;
			
            var hddNgayNhanDon = document.getElementById('<%=hddNgayNhanDon.ClientID%>');
            var NgayNhanDon = hddNgayNhanDon.value;
            if (!SoSanh2Date(txtNgayBanGiao, "Ngày bàn giao", NgayNhanDon, "Ngày nhận đơn"))
                    return false;
		    //----------------------------
            var rdbTuCachToTung = document.getElementById('<%=rdbTuCachToTung.ClientID%>');
            var msg = 'Bạn chưa chọn tư cách tố tụng. Hãy chọn lại!';
            if (!CheckChangeRadioButtonList(rdbTuCachToTung, msg))
                return false;
			//----------------------------
            var ddlNguoiBanGiao = document.getElementById('<%=ddlNguoiBanGiao.ClientID%>');
            var val = ddlNguoiBanGiao.options[ddlNguoiBanGiao.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn người bàn giao. Hãy chọn lại!');
                ddlNguoiBanGiao.focus();
                return false;
            }
			//----------------------------
            var ddlNguoiNhan = document.getElementById('<%=ddlNguoiNhan.ClientID%>');
            var val = ddlNguoiNhan.options[ddlNguoiNhan.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn người nhận. Hãy chọn lại!');
                ddlNguoiNhan.focus();
                return false;
            }
			//----------------------------
            var txtTenTL = document.getElementById('<%=txtTenTL.ClientID%>');
            if (!Common_CheckTextBox(txtTenTL, "Tên tài liệu")) {
                return false;
            }

            return true;
        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }

        function uploadComplete() {
            __doPostBack('tctl00$UpdatePanel1', '');
        }
        function Setfocus(controlid) {
            var ctrl = document.getElementById(controlid);
            ctrl.focus();
        }
    </script>
</asp:Content>
