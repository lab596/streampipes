/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import {Component, Input} from "@angular/core";
import {Pipeline} from "../../../core-model/gen/streampipes-model";
import {PipelineService} from "../../../platform-services/apis/pipeline.service";
import {DialogRef} from "../../../core-ui/dialog/base-dialog/dialog-ref";

@Component({
    selector: 'delete-adapter-dialog',
    templateUrl: './delete-adapter-dialog.component.html',
    styleUrls: ['./delete-adapter-dialog.component.scss']
})
export class DeleteAdapterDialogComponent {

    @Input()
    pipeline: Pipeline;

    isInProgress: boolean = false;
    currentStatus: any;

    constructor(private dialogRef: DialogRef<DeleteAdapterDialogComponent>,
                private pipelineService: PipelineService) {
    }

    close(refreshPipelines: boolean) {
        this.dialogRef.close(refreshPipelines);
    };

    deleteAdapter() {
        this.isInProgress = true;
        this.currentStatus = "Deleting pipeline...";
        this.pipelineService.deleteOwnPipeline(this.pipeline._id)
            .subscribe(data => {
                this.close(true);
            });
    }

    stopAndDeleteAdapter() {
        this.isInProgress = true;
        this.currentStatus = "Stopping pipeline...";
        this.pipelineService.stopPipeline(this.pipeline._id)
            .subscribe(data => {
               this.deleteAdapter();
            }, data => {
                this.deleteAdapter();
            });
    }
}
