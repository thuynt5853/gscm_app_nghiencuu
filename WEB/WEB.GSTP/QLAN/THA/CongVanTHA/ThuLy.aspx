<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThuLy.aspx.cs"
    Inherits="WEB.GSTP.QLAN.THA.CongVanTHA.ThuLy" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <style>
        .boxchung {
            float: left;
            width: 99%;
            margin-left: 0;
        }

        .title_ds {
            float: left;
            width: 100%;
            background: #fff none repeat scroll 0 0;
            white-space: nowrap;
            margin-bottom: 5px;
            text-transform: uppercase;
        }

        .ngay_cv {
            width: 120px;
            line-height: 25px;
        }
    </style>
    <asp:HiddenField ID="hddBiAnID" Value="0" runat="server" />
    <asp:HiddenField ID="hddVuAnID" Value="0" runat="server" />
    <asp:HiddenField ID="hddThuLyID" Value="0" runat="server" />
    <div class="box">
        <div class="box_nd" style="min-height: 850px;">
            <asp:Panel ID="pn" runat="server">
                <div class="content_form">
                <!---------------------------------------->
                <div class="boxchung">
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;" > <asp:Literal ID="lttMsg" runat="server"></asp:Literal></div>
                    <h4 class="tleboxchung bg_title_group bg_green">Loại tài liệu</h4>
                    <div class="boder" style="padding: 20px 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 85px;">Loại</td>
                                <td>
                                    <asp:RadioButtonList ID="rdLoaiDon" runat="server"
                                        RepeatDirection="Horizontal"
                                        AutoPostBack="true" OnSelectedIndexChanged="rdLoaiDon_SelectedIndexChanged">
                                        <asp:ListItem Selected="True" Value="0">Công văn</asp:ListItem>
                                        <asp:ListItem Value="1">Đơn</asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>

                            <asp:Panel ID="pnRowLoai" runat="server" Visible="false">
                                <tr>
                                    <td>Người làm đơn</td>
                                    <td>
                                        <asp:RadioButtonList ID="rdNguoiLamDon" runat="server"
                                            RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdNguoiLamDon_SelectedIndexChanged">
                                            <asp:ListItem Selected="True" Value="0">Bị án</asp:ListItem>
                                            <asp:ListItem Value="1">Người thân</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                            </asp:Panel>
                        </table>
                    </div>
                </div>
               
                <!---------------------------------------->
                <div class="boxchung">
                    <h4 class="tleboxchung bg_title_group bg_green">
                        <asp:Literal ID="lttGroup" runat="server" Text="Thông tin công văn"></asp:Literal></h4>
                    <div class="boder" style="padding: 20px 10px;">
                        
                        <table class="table1">
                            <asp:Panel ID="pnCongVanEdit" runat="server">
                                <tr>
                                    <td style="width: 95px;">Số công văn<span class="batbuoc">(*)</span></td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtSoCongVan" CssClass="user"
                                            runat="server" Width="242px"></asp:TextBox>

                                    </td>
                                    <td style="width: 85px;">Ngày làm công văn<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayCongVan" runat="server" CssClass="user"
                                            Width="90px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server"
                                            TargetControlID="txtNgayCongVan" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server"
                                            TargetControlID="txtNgayCongVan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>

                                <tr>
                                    <td>Tên cơ quan<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtTenCoQuan" CssClass="user"
                                            runat="server" Width="242px"></asp:TextBox>
                                    </td>
                                    <td>Địa chỉ</td>
                                    <td>
                                        <asp:TextBox ID="txtDiaChi" CssClass="user"
                                            runat="server" Width="362px"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>Người ký<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNguoiKy" CssClass="user"
                                            runat="server" Width="242px"></asp:TextBox>
                                    </td>
                                    <td>Chức vụ<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtChucVu" CssClass="user"
                                            runat="server" Width="362px"></asp:TextBox></td>
                                </tr>
                            </asp:Panel>

                            <asp:Panel ID="pnDon" runat="server" Visible="false">
                                <tr>
                                    <td style="width: 95px;">Số thụ lý<span class="batbuoc">(*)</span></td>
                                    <td style="width: 260px">
                                        <div style="float: left;">
                                            <asp:TextBox ID="txtDon_SoThuLy" CssClass="user"
                                                runat="server" Width="70px"></asp:TextBox>
                                        </div>
                                        <div style="float: right; margin-right: 13px;">
                                            <span style="width: 70px;">Ngày thụ lý<span class="batbuoc">(*)</span></span>

                                            <asp:TextBox ID="txtDon_NgayThuLy" runat="server" CssClass="user"
                                                Width="65px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server"
                                                TargetControlID="txtDon_NgayThuLy" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                                                TargetControlID="txtDon_NgayThuLy" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                ErrorTooltipEnabled="true" />
                                        </div>
                                    </td>
                                    <asp:Panel ID="pnDon_BiAn" runat="server" Visible="true">
                                        <td style="width: 100px">Ngày làm đơn<span class="batbuoc">(*)</span>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDon_NgayLamCongVan" runat="server" CssClass="user"
                                                Width="90px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server"
                                                TargetControlID="txtDon_NgayLamCongVan" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server"
                                                TargetControlID="txtDon_NgayLamCongVan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                ErrorTooltipEnabled="true" />
                                        </td>
                                    </asp:Panel>
                                </tr>

                                <asp:Panel ID="pnDon_NguoiThan" runat="server" Visible="false">
                                    <tr>
                                        <td>Người làm đơn<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtDon_NguoiLamDon" CssClass="user"
                                                runat="server" Width="242px"></asp:TextBox></td>
                                        <td style="width: 100px;">Ngày sinh<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <div style="float: left;">
                                                <asp:TextBox ID="txtDon_NgaySinh" runat="server" CssClass="user"
                                                    Width="90px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender5" runat="server"
                                                    TargetControlID="txtDon_NgaySinh" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server"
                                                    TargetControlID="txtDon_NgaySinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                    ErrorTooltipEnabled="true" />
                                            </div>
                                            <div style="float: left; margin-left: 10px;">
                                                <span>CMND<span class="batbuoc">(*)</span></span>
                                                <asp:TextBox ID="txtDon_CMND" CssClass="user"
                                                    runat="server" Width="195px"></asp:TextBox>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Quan hệ với bị án<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtDon_QuanHeVoiBiAn" CssClass="user"
                                                runat="server" Width="242px"></asp:TextBox></td>
                                        <td>Quốc tịch</td>
                                        <td>
                                            <asp:DropDownList ID="dropDon_QuocTich" CssClass="chosen-select"
                                                Width="370px" runat="server">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Hộ khẩu thường trú<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtDon_HoKhauTT" CssClass="user"
                                                runat="server" Width="242px"></asp:TextBox>
                                        </td>
                                        <td>Nơi đăng ký tạm trú<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtDon_TamTru" CssClass="user"
                                                runat="server" Width="362px"></asp:TextBox></td>
                                    </tr>
                                </asp:Panel>
                            </asp:Panel>
                            <tr>
                                <td>Yêu cầu<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="dropYeuCau" CssClass="chosen-select"
                                        AutoPostBack="true"
                                        Width="250px"
                                        runat="server" OnSelectedIndexChanged="dropYeuCau_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td>Lý do<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="dropLyDo" CssClass="chosen-select"
                                        Width="370px" runat="server">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>Ý kiến của xã/phường</td>
                                <td>
                                    <asp:TextBox ID="txtYKien" CssClass="user"
                                        runat="server" Width="242px"></asp:TextBox>
                                </td>

                                <td>Ngày nhận<span class="batbuoc">(*)</span></td>
                                <td>
                                    <div style="float: left;">

                                        <asp:TextBox ID="txtNgayNhan" runat="server" CssClass="user"
                                            Width="90px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                            TargetControlID="txtNgayNhan" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                            TargetControlID="txtNgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                    </div>


                                    <div style="float: left; line-height: 20px; margin-left: 35px; margin-right: 5px;">Người nhận<span class="batbuoc">(*)</span></div>
                                        <asp:DropDownList ID="dropNguoiNhan" CssClass="chosen-select" Width="150px"
                                            runat="server">
                                        </asp:DropDownList>

                                </td>
                            </tr>
                            <tr>
                                <td>File đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePath" runat="server" Value="" />
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoad" CssClass="floatF" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF"/>
                                    <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                    <asp:LinkButton ID="lbtAddFile" CssClass="linkAddFile" Visible="false" runat="server" Text="Thêm file đính kèm"></asp:LinkButton>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"></td>
                                <td colspan="2">
                                    <asp:Button ID="cmdSave" runat="server" CssClass="buttoninput" Text="Lưu"
                                        OnClick="cmdSave_Click" OnClientClick="return validate_form();" /></td>
                            </tr>
                        </table>
                    </div>
                </div>
               <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                <asp:Literal ID="lstMsgTop" runat="server"></asp:Literal>
            </div>
                <!---------------------------------------->
                <div class="boxchung">
                    <h4 class="title_ds">Danh sách thụ lý công văn/ đơn</h4>
                    <table class="table2" width="100%" border="1">
                        <tr class="header">
                            <td width="42">
                                <div align="center"><strong>TT</strong></div>
                            </td>
                           <td width="100">
                                <div align="center"><strong>Loại</strong></div>
                            </td>
                            <td width="80">
                                <div align="center"><strong>Số công văn</strong></div>
                            </td>
                            <td width="140">
                                <div align="center"><strong>Ngày làm công văn/ đơn</strong></div>
                            </td>
                            <td>
                                <div align="center"><strong>Yêu cầu</strong></div>
                            </td>
                            <td width="65">
                                <div align="center"><strong>File đính kèm</strong></div>
                            </td>
                            <td width="70">
                                <div align="center"><strong>Thao tác</strong></div>
                            </td>
                        </tr>
                        <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand"  OnItemDataBound="rpt_ItemDataBound">
                            <ItemTemplate>
                                <tr>
                                    <td>   <%# Container.ItemIndex + 1 %></td>
                                    <td><%# Eval("LoaiDon") %></td>
                                    <td><%# Eval("SoCV_Don") %></td>
                                    <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayCV_Don")) %></td>
                                    <td><%# Eval("TenYeuCau") %></td>
                                    <td>
                                        <div align="center">
                                            <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                                    CommandArgument='<%#Eval("ID") %>' ToolTip='<%#Eval("FILE_ID")%>' />
                                        </div>

                                    </td>
                                    <td>
                                        <div class="align_center">
                                            <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false"
                                                CommandName="sua" ForeColor="#0e7eee" ToolTip="Sửa"
                                                CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                            &nbsp;&nbsp;
                                            <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee" CommandName="Xoa"
                                                                        CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                                   
                                        </div>
                                    </td>
                                     <td style="display: none;">
                                        <asp:HiddenField ID="hddToaGiaiQuyetID" runat="server" Value='<%#Eval("TOA_GIAIQUYET_ID") %>' />
                                     </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </table>


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
    </script>

    <script>
        function validate_form() {
            var rdLoaiDon = document.getElementById('<%=rdLoaiDon.ClientID%>');
            var selected_value = GetStatusRadioButtonList(rdLoaiDon);
            if (selected_value == "1") {
                //Check don
                if (!validate_don())
                    return false;
            }
            else {
                //check cong van
                if (!validate_congvan())
                    return false;
            }

            //-----------------chung --------------
            var value_change = "";
            var dropYeuCau = document.getElementById('<%= dropYeuCau.ClientID%>');
            value_change = dropYeuCau.options[dropYeuCau.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn mục "Yêu cầu". Hãy kiểm tra lại!');
                dropYeuCau.focus();
                return false;
            }

            var dropLyDo = document.getElementById('<%= dropLyDo.ClientID%>');
            if (value_change != "521" && value_change != "522" && value_change != "1757") {
                value_change = dropLyDo.options[dropLyDo.selectedIndex].value;
                if (value_change == "0") {
                    alert('Bạn chưa chọn mục "Lý do". Hãy kiểm tra lại!');
                    dropLyDo.focus();
                    return false;
                }
            }

            var txtNgayNhan = document.getElementById('<%= txtNgayNhan.ClientID%>');
            if (!CheckDateTimeControl(txtNgayNhan, 'Ngày nhận'))
                return false;


            var NgaySoSanh = txtNgayNhan.value;
            if (selected_value == "1") {
                //Check don
                var txtDon_NgayThuLy = document.getElementById('<%= txtDon_NgayThuLy.ClientID%>');
                NgaySoSanh = txtDon_NgayThuLy.value;
                if (!SoSanh2Date(txtNgayNhan, 'Ngày nhận', NgaySoSanh, 'Ngày  thụ lý'))
                    return false;
            }
            else {
                //check cong van
                var txtNgayCongVan = document.getElementById('<%= txtNgayCongVan.ClientID%>');
                NgaySoSanh = txtNgayCongVan.value;
                if (!SoSanh2Date(txtNgayNhan, 'Ngày nhận', NgaySoSanh, 'Ngày công văn'))
                    return false;
            }
            
            var dropNguoiNhan = document.getElementById('<%= dropNguoiNhan.ClientID%>');
            value_change = dropNguoiNhan.options[dropNguoiNhan.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn mục "Người nhận". Hãy kiểm tra lại!');
                dropNguoiNhan.focus();
                return false;
            }

            return true;
        }

        function validate_congvan()
        {
            var txtSoCongVan = document.getElementById('<%= txtSoCongVan.ClientID%>');
            if (!Common_CheckTextBox(txtSoCongVan, "số công văn"))
                return false;

            var txtNgayCongVan = document.getElementById('<%= txtNgayCongVan.ClientID%>');
            if (!CheckDateTimeControl(txtNgayCongVan, 'Ngày làm công văn'))
                return false;

            var txtTenCoQuan = document.getElementById('<%= txtTenCoQuan.ClientID%>');
            if (!Common_CheckTextBox(txtTenCoQuan, "tên cơ quan"))
                return false;

            var txtDiaChi = document.getElementById('<%= txtDiaChi.ClientID%>');
            if (Common_CheckEmpty(txtDiaChi.value)) {
                if (!Common_CheckTextBox(txtDiaChi, "địa chỉ"))
                    return false;
            }

            var txtNguoiKy = document.getElementById('<%= txtNguoiKy.ClientID%>');
            if (!Common_CheckTextBox(txtNguoiKy, "Người ký công văn"))
                return false;

            var txtChucVu = document.getElementById('<%= txtChucVu.ClientID%>');
            if (!Common_CheckTextBox(txtChucVu, "Chức vụ"))
                return false;

            return true;
        }
        function validate_don() {
            var txtDon_SoThuLy = document.getElementById('<%= txtDon_SoThuLy.ClientID%>');
            if (!Common_CheckTextBox(txtDon_SoThuLy, "số thụ lý"))
                return false;
            
            var txtDon_NgayThuLy = document.getElementById('<%= txtDon_NgayThuLy.ClientID%>');
            if (!CheckDateTimeControl(txtDon_NgayThuLy, 'Ngày thụ lý'))
                return false;

            //-----------------------
            var rdNguoiLamDon = document.getElementById('<%=rdNguoiLamDon.ClientID%>');
            var selected_value = GetStatusRadioButtonList(rdNguoiLamDon);
           
            if (selected_value ==1) {
                //nguoi than
                var txtDon_NguoiLamDon = document.getElementById('<%= txtDon_NguoiLamDon.ClientID%>');
                if (!Common_CheckTextBox(txtDon_NguoiLamDon, "thông tin người làm đơn"))
                    return false;

                var txtDon_NgaySinh = document.getElementById('<%= txtDon_NgaySinh.ClientID%>');
                if (!CheckDateTimeControl(txtDon_NgaySinh, 'Ngày sinh của người làm đơn'))
                    return false;
                var NgaySoSanh = txtDon_NgaySinh.value;
                if (!SoSanh2Date(txtDon_NgayThuLy, 'Ngày thụ lý', NgaySoSanh, 'Ngày sinh của người làm đơn')) {
                    txtDon_NgaySinh.focus();
                    return false;
                }

                var txtDon_CMND = document.getElementById('<%= txtDon_CMND.ClientID%>');
                if (!Common_CheckTextBox(txtDon_CMND, "số CMND của người làm đơn"))
                    return false;

                var txtDon_QuanHeVoiBiAn = document.getElementById('<%= txtDon_QuanHeVoiBiAn.ClientID%>');
                if (!Common_CheckTextBox(txtDon_QuanHeVoiBiAn, "thông tin quan hệ với bị án"))
                    return false;

                if (!Common_CheckTextBox(txtDon_HoKhauTT, "thông tin hộ khẩu thường trú của người làm đơn"))
                    return false;

                var txtDon_TamTru = document.getElementById('<%= txtDon_TamTru.ClientID%>');
                if (!Common_CheckTextBox(txtSoCongVan, "thông tin hộ khẩu tạm trú của người làm đơn"))
                    return false;
            }
            else {
                // bi an
                var txtDon_NgayLamCongVan = document.getElementById('<%= txtDon_NgayLamCongVan.ClientID%>');
                if (!CheckDateTimeControl(txtDon_NgayLamCongVan, 'Ngày làm đơn'))
                    return false;

                var NgaySoSanh = txtDon_NgayLamCongVan.value;
                if (!SoSanh2Date(txtDon_NgayThuLy, 'Ngày thụ lý', NgaySoSanh, 'Ngày làm đơn'))
                {
                    txtDon_NgayThuLy.focus();
                    return false;
                }
            }
            return true;
        }
    </script>
</asp:Content>
