<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="KQDeNghiKienNghi.aspx.cs" Inherits="WEB.GSTP.QLAN.HOAGIAI.KQDeNghiKienNghi" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <script type="text/javascript" src="../../UI/js/Common.js"></script>

    <style type="text/css">
        .Col1 {
            width: 125px;
        }

        .Col2 {
            width: 260px;
        }

        .Col3 {
            width: 145px;
        }

        .Col4 {
            width: 250px;
        }

        .Drop1Col {
            width: 250px;
        }

        .Drop3Col {
            width: 668px;
        }

        .txtCalendar {
            width: 110px;
        }

        .d-file-upload div input {
            border: solid 1px #cccccc;
            border-radius: 4px;
            height: 20px;
            font-size: 12px;
            font-family: Arial, Helvetica, sans-serif;
            color: #044271;
            padding: 2px 3px;
            text-indent: 3px;
        }

        .d-not-vaild {
            border: solid 1px red !important;
        }

        .d-validator-message {
            color: red;
        }

        .mt-2 {
            margin-top: 5px;
        }
        /*        table, th, td {
  border: 1px solid;
}*/
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddDeNghi" Value="1" runat="server" />
    <asp:HiddenField ID="hddLoaiAn" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <div class="box">
        <div class="box_nd">

            <div class="boxchung">
                <h4 class="tleboxchung">
                    <asp:Label runat="server" ID="lbTitle" Text="Thông tin thụ lý đề nghị/kiến nghị"></asp:Label>
                </h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <asp:TextBox ID="txtKetQuaDNKNID" runat="server" Visible="false" />
                        <tr>
                            <td class="Col1">Ngày giao<span class="batbuoc">(*)</span></td>
                            <td class="Col2">
                                <asp:TextBox ID="txtNgayGiao" runat="server"
                                    AutoPostBack="False" CssClass="user txtCalendar d-validator-required" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtNgayGiaoCalendarExtender" runat="server" TargetControlID="txtNgayGiao" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="txtNgayGiaoMaskedEditExtender" runat="server" TargetControlID="txtNgayGiao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td class="Col3">Ngày nhận<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNgayNhan" runat="server"
                                    AutoPostBack="False" CssClass="user txtCalendar d-validator-required" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayNhan" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td class="Col1">Ngày thụ lý<span class="batbuoc">(*)</span></td>
                            <td class="Col2">
                                <asp:TextBox ID="txtNgayThuLy" runat="server" CssClass="user txtCalendar d-validator-required"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayThuLy"
                                    Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayThuLy"
                                    Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td class="Col3">Số thụ lý<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtSoThuLy" CssClass="user d-validator-required" runat="server" Width="242px"></asp:TextBox>
                            </td>
                        </tr>
                        </table>
                    </div>
                </div>
            <div class="boxchung">
                <h4 class="tleboxchung">
                    <asp:Label runat="server" ID="lblTitle" Text="Thông tin giải quyết đề nghị/kiến nghị"></asp:Label>
                </h4>
                        <div class="boder" style="padding:10px;">
                            <table class="table1">
                        <tr>
                            <td class="Col1">Thẩm phán<span class="batbuoc">(*)</span></td>
                            <td class="Col2">
                                <asp:DropDownList ID="ddlThamphan" AutoPostBack="False" CssClass="user chosen-select Drop1Col" runat="server">
                                </asp:DropDownList>
                            </td>
                            <td class="Col3">Toà án trực thuộc</td>
                            <td>
                                <asp:DropDownList ID="ddlToaAnTrucThuoc" Enabled="False" CssClass="user chosen-select Drop1Col" runat="server"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="Col1">Kết quả giải quyết đề nghị/ kiến nghị<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:DropDownList ID="ddlKetQuaDNKN" CssClass="chosen-select Drop3Col" runat="server" AutoPostBack="False">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="Col1">Ngày quyết định<span class="batbuoc">(*)</span></td>
                            <td class="Col2">
                                <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user txtCalendar d-validator-required"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayQD"
                                    Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayQD"
                                    Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td class="Col3">Số quyết định<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtSoQD" CssClass="user d-validator-required" runat="server" Width="242px"></asp:TextBox>
                            </td>
                        </tr>
                        <%--            <tr>
                            <asp:Panel ID="pnZonekythuong" runat="server">
                                <td class="Col1">Tệp đính kèm</td>
                                <td colspan="3">
                                    <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                    <asp:HiddenField ID="hddSessionID" runat="server" />
                                    <asp:HiddenField ID="hddURLKS" runat="server" />
                                    <asp:HiddenField ID="hddFilePath" runat="server" Value="" />
                                    <div id="zonekythuong" style="margin-top: 10px; width: 80%;">
                                        <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                            ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" CssClass="d-file-upload" />
                                        <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                    </div>

                                    <div style="display: none">
                                        <asp:Button ID="cmdThemFileTL" runat="server"
                                            Text="Them tai lieu" />
                                    </div>
                                </td>
                            </asp:Panel>
                        </tr>--%>
                        <tr>
                            <td colspan="1000" style="padding-top: 20px">
                                <asp:Label runat="server" CssClass="d-thongbao" ID="lblThongBao" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>
          


            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" align="center">
                            <%--                            <asp:Button ID="btnUpdate" runat="server" CssClass="buttoninput"
                                Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return validate()" />--%>

                            <%--<asp:Button ID="btnLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />--%>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>

                            <asp:Panel runat="server" ID="pndata" Visible="true">
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-Width="45px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:BoundColumn DataField="KETQUA_TEXT" HeaderText="Kết quả giải quyết đề nghị/ kiến nghị" HeaderStyle-Width="300px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="THAMPHAN_HOTEN" HeaderText="Thẩm phán" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYGIAO" HeaderText="Ngày giao" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYNHAN" HeaderText="Ngày nhận" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>

                                        <asp:BoundColumn DataField="SOQUYETDINH" HeaderText="Số QĐ" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYQUYETDINH" HeaderText="Ngày QĐ" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TOAAN_TRUC_THUOC" HeaderText="Tòa án trực thuộc" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <%--     <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                            <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                                    CommandArgument='<%#Eval("FILESID") %>' Visible="true" />
                                                <asp:Label ID="lblKhongCoFile" Height="30px" Visible="true" runat="server" Text=""></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>--%>
                                        <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>

            </div>
        </div>
    </div>
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
        function EndRequestHandler(sender, args) {
            if (args.get_error() != undefined) {
                args.set_errorHandled(true);
            }
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function ThongBaoOnHide() {
            $(".d-thongbao").delay(3000).fadeOut(300);
            //validate();
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
            //CheckKyso();
        }
        function validate() {
            let isPass = true;
            let countRun = 0;
            let total = $(".d-validator-required").length;
            $(".d-validator-required").each(function (index, element) {
                let isVaild = false;
                let type = $(this)[0].localName;
                let value = $(this).val();
                switch (type) {
                    case 'select':
                        if (value == null || value == "" || value == 0) {
                            isVaild = false;
                        } else {
                            isVaild = true;
                        }
                        break;
                    case 'table':
                        //radio
                        $(this).find("input:checked").each(function (index, element) {
                            value = $(element).val();
                            return;
                        });
                        if (value == null || value == "") {
                            isVaild = false;
                        } else {
                            isVaild = true;
                        }
                        break;
                    default:
                        if (value == null || value == "") {
                            isVaild = false;
                        } else {
                            isVaild = true;
                        }
                        break;
                }
                if (!isVaild) {
                    let message = $(this).parent().find('.d-validator-message');
                    if (message.length == 0) {
                        $(this).parent().append(`<span class="d-validator-message mt-1"></span>`);
                        message = $(this).parent().find('.d-validator-message');
                    }
                    message.text("Không được để trống");
                    message.css("display", "unset")
                    message.css("visibility", "inherit")
                    let inputClass = $(this);
                    switch (type) {
                        case 'select':
                            inputClass = $(this).parent().find('a.chosen-single');
                            break;
                        default:
                            break;
                    }
                    inputClass.addClass("d-not-vaild");
                    isPass = false;
                }
                countRun++;
            });
            while (countRun < total)
                break;
            if (isPass == false)
                alert("Hãy điền đầy đủ thông tin");
            return isPass;
        }
        $(document).on('blur', '.d-validator-required', function (event) {
            $(this).parent().find('.d-validator-message').css("display", "none")
            let type = $(this)[0].localName;
            let inputClass = $(this);
            switch (type) {
                case 'select':
                    inputClass = $(this).parent().find('a.chosen-single');
                    break;
                default:
                    break;
            }
            inputClass.removeClass("d-not-vaild");
        });


<%--        var count_file = 0;


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
                $("#<%= cmdThemFileTL.ClientID %>").click();
            } else {
                document.getElementById("_signature").value = received_msg.Message;
            }
        }--%>

        //metadata có kiểu List<KeyValue>
        //KeyValue là class { string Key; string Value; }
<%--        function exc_sign_file1() {
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
        }--%>

    </script>
</asp:Content>
