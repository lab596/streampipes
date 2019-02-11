/*
 * Copyright 2018 FZI Forschungszentrum Informatik
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package org.streampipes.wrapper.params.runtime;

import org.streampipes.model.base.InvocableStreamPipesEntity;
import org.streampipes.model.runtime.Event;
import org.streampipes.model.runtime.EventFactory;
import org.streampipes.model.runtime.SchemaInfo;
import org.streampipes.model.runtime.SourceInfo;
import org.streampipes.wrapper.context.RuntimeContext;
import org.streampipes.wrapper.params.binding.BindingParams;

import java.util.HashMap;
import java.util.Map;

public abstract class RuntimeParams<B extends BindingParams<I>, I extends
        InvocableStreamPipesEntity> {

  protected final B bindingParams;
  private RuntimeContext runtimeContext;

  private Map<String, Integer> eventInfoMap = new HashMap<>();

  private Boolean singletonEngine;

  public RuntimeParams(B bindingParams, Boolean singletonEngine) {
    this.bindingParams = bindingParams;
    this.singletonEngine = singletonEngine;
    buildEventInfoMap();
    makeRuntimeContext();
  }

  public B getBindingParams() {
    return bindingParams;
  }

  private void buildEventInfoMap() {
    for (int i = 0; i < bindingParams.getInputStreamParams().size(); i++) {
      String sourceInfo = bindingParams.getInputStreamParams().get(i).getSourceInfo()
              .getSourceId();
      eventInfoMap.put(sourceInfo, i);
    }
  }

  public Event makeEvent(Map<String, Object> mapEvent, String sourceId) {
    return EventFactory.fromMap(mapEvent, getSourceInfo(getIndex(sourceId)), getSchemaInfo
            (getIndex(sourceId)));

  }

  private void makeRuntimeContext() {

  }

  public SourceInfo getSourceInfo(Integer index) {
    return bindingParams.getInputStreamParams().get(index).getSourceInfo();
  }

  public SchemaInfo getSchemaInfo(Integer index) {
    return bindingParams.getInputStreamParams().get(index).getSchemaInfo();
  }

  private Integer getIndex(String sourceId) {
    return eventInfoMap.get(sourceId);
  }

  public RuntimeContext getRuntimeContext() {
    return runtimeContext;
  }

  public Boolean isSingletonEngine() {
    return singletonEngine;
  }


}
